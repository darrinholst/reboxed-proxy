class RedboxMetadata
  attr_accessor :url

  def initialize(url)
    self.url = url
  end

  def add_to(title)
    puts "adding metadata to #{title.name}(#{title.id})"

    postData = JSON.generate({
      "productType" => title.product_type,
      "id" => title.id,
      "__K" => "UNKNOWN"
    })

    headers = {
      "Cookie" => "RB_2.0=1",
      "Content-Type" => 'application/json; charset=utf-8'
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

