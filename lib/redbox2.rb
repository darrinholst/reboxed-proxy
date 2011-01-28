class Redbox2
  attr_accessor :key, :cookies

  def initialize(key, cookies)
    self.key = key
    self.cookies = cookies
  end

  def sync
    url = "http://www.redbox.com/api/product/js/__titles"
    p "getting #{url}"
    resp = RestClient.get("http://www.redbox.com/api/Product/GetDetail/", cookies)

    match = /=\ *(\[.*\])/.match(resp.body)
    raise "couldn't find movies in #{resp.body}" unless match

    json = JSON.parse(match[1])
    p "found #{json.length} movies"
    new_movies = 0

    json.each_with_index do |row, i|
      if(row["releaseDays"].to_i >= -14)
        begin
          Title.find(row["ID"])
        rescue ActiveRecord::RecordNotFound => e
          title = Title.new
          title.id = row['ID']
          title.name = row['name']
          title.sort_name = row['sortName']
          title.image = row['img']
          title.released = Date.parse(row['release'])
          title.product_type = row['productType']

          p "adding #{title.name}"
          title.save

          add_metadata_to(title)
          new_movies += 1
        end
      end
    end

    new_movies
  end

  private

  def add_metadata_to(title)
    p "adding metadata to #{title.name}(#{title.id})"

    postData = JSON.generate({
      "productType" => title.product_type,
      "id" => title.id,
      "descCharLimit" => 2000
    })

    headers = {
      "Cookie" => cookies.map{|k,v| "#{k}=#{v}"}.join("; "),
      "Content-Type" => 'application/x-www-form-urlencoded',
      "__K" => key,
      "User-Agent" => "Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10_6_5; en-US) AppleWebKit/534.10 (KHTML, like Gecko) Chrome/8.0.552.231 Safari/534.10",
      "X-Requested-With" => "XMLHttpRequest"
    }

    resp = RestClient.post(url, postData, headers)
    json = JSON.parse(resp.body)

    if(json["d"] && json["d"]["success"] && json["d"]["data"])
      data = json["d"]["data"]
      title.update_attributes({
        :description => data["desc"] || "Unknown",
        :rating => data["rating"],
        :running_time => data["len"],
        :actors => (data["starring"] || []).join(", "),
        :genre => (data["genre"] || []).join(", "),
      })
    else
      raise "WTF, no metadata - " + resp
    end
  end
end
