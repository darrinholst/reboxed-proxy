class Redbox
  attr_accessor :key, :cookies, :version

  def initialize
    resp = RestClient.get("http://www.redbox.com")
    check_for_10_key(resp)
    check_for_20_key(resp)
    save_cookies(resp)
  end

  def sync
    api.sync
  end

  private

  def api
    if self.version == 2
      Redbox2.new(key, cookies)
    else
      Redbox1.new(key, cookies)
    end
  end

  def save_cookies(resp)
    self.cookies = parse_cookies(resp.headers[:set_cookie])
    p self.cookies
  end

  def check_for_10_key(resp)
    check_for_match(resp, /__K.*value="(.*)"/, 1)
  end

  def check_for_20_key(resp)
    check_for_match(resp, /rb\.api\.key *= * [',"](.*?)[',"]/, 2)
  end

  def check_for_match(resp, regex, api_version)
    match = resp.body.match(regex)
    self.key = match[1] if match
    self.version = api_version if match
    p "matched on #{regex}" if match
  end

  def parse_cookies(cookies)
    out = {}

    [cookies].flatten.each do |raw_cookie|
      raw_cookie.split(";").each do |cookie_part|
        key, val = cookie_part.strip.split("=", 2)

        unless %w(expires domain path secure HttpOnly).member?(key)
          out[key] = val
        end
      end
    end

    out
  end
end
