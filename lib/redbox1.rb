class Redbox1
  attr_accessor :key, :cookies

  def initialize(key, cookies)
    self.key = key
    self.cookies = cookies
  end

  def sync
    url = "http://www.redbox.com/data.svc/Title/js"
    p "getting #{url}"
    resp = RestClient.get(url, cookies)

    match = /=\ *(\[.*\]);/.match(resp.body)
    raise "couldn't find movies in #{resp.body}" unless match

    json = JSON.parse(match[1])
    puts "found #{json.length} movies"
    new_movies = 0

    json.each do |row|
      begin
        Title.find(row["ID"])
      rescue ActiveRecord::RecordNotFound => e
        title = Title.new
        title.id = row['ID']
        title.name = row['Name']
        title.sort_name = row['SortName']
        title.image = row['Img']
        title.released = Date.parse(row['Release'])
        title.product_type = row['ProductType']

        p "adding #{title.name}"
        title.save

        add_metadata_to(title)
        new_movies += 1
      end
    end

    new_movies
  end

  private

  def add_metadata_to(title)
    puts "adding metadata to #{title.name}(#{title.id})"

    postData = JSON.generate({
      "type" => "Title",
      "pk" => "ID",
      "statements" => [{
        "filters" => {"ID" => title.id},
        "sort" => nil,
        "flags" => nil
      }],
      "__K" => key
    })

    headers = {
      'Cookie' => cookies.map{|k,v| "#{k}=#{v}"}.join("; "),
      'Content-Type' => 'application/json; charset=utf-8'
    }

    resp = RestClient.post("http://www.redbox.com/data.svc/Title", postData, headers)

    match = /\{.*?\:(.*)\}/.match(resp.body)
    raise "couldn't find metadata in #{resp.body}" unless match

    json = JSON.parse(match[1])

    title.update_attributes({
      :description => json["Desc"] || "Unknown",
      :rating => json["Rating"],
      :running_time => json["RunningTime"],
      :actors => json["Actors"],
      :genre => json["Genre"],
    })
  end
end
