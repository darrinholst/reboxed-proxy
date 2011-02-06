class Redbox
  attr_accessor :key, :cookies

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
    if is_2_0?
      Redbox2.new(key, cookies)
    else
      Redbox1.new(key, cookies)
    end
  end

  def is_2_0?
    cookies.has_key? "RB_2.0"
  end

  def save_cookies(resp)
    self.cookies = parse_cookies(resp.headers[:set_cookie])
    p self.cookies
  end

  def check_for_10_key(resp)
    check_for_match(resp, /__K.*value="(.*)"/)
  end

  def check_for_20_key(resp)
    check_for_match(resp, /rb\.api\.key *= * [',"](.*?)[',"]/)
  end

  def check_for_match(resp, regex)
    match = resp.body.match(regex)
    self.key = match[1] if match
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
