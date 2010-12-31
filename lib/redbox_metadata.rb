class RedboxMetadata
  attr_accessor :url, :token, :cookies

  def initialize(url)
    self.url = url
    initialize_token
  end

  def initialize_token
    resp = RestClient.get("http://www.redbox.com", :cookies => {"RB_2.0" => "1"})
    self.token = resp.body.match(/rb\.api\.key *= * [',"](.*?)[',"]/)[1]
    self.cookies = parse_cookies(resp.headers[:set_cookie])
    p "cookies = #{cookies}"
    p "token = #{token}"
  end

  def parse_cookies(cookies)
    out = {}

    [cookies].flatten.each do |raw_cookie|
      raw_cookie.split("; ").each do |cookie_part|
        key, val = cookie_part.split("=", 2)

        unless %w(expires domain path secure HttpOnly).member?(key)
          out[key] = val
        end
      end
    end

    out["RB_2.0"] = "1"
    out
  end

  def add_to(title)
    puts "adding metadata to #{title.name}(#{title.id})"

    postData = JSON.generate({
      "productType" => title.product_type,
      "id" => title.id,
      "descCharLimit" => 2000
    })

    headers = {
      "Cookie" => cookies.map{|k,v| "#{k}=#{v}"}.join("; "),
      "Content-Type" => 'application/x-www-form-urlencoded',
      "__K" => token,
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

