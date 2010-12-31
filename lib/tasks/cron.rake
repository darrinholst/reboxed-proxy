TITLES_URL = "http://www.redbox.com/api/product/js/__titles"
METADATA_URL = "http://www.redbox.com/api/Product/GetDetail/"

module Net::HTTPHeader
  def capitalize(name)
    return "__K" if name.eql? "__k"
    name.split(/-/).map {|s| s.capitalize }.join('-')
  end
end

task :cron => :environment do
  if RedboxSlurper.new(TITLES_URL, METADATA_URL).slurp_titles > 0
    puts "clearing cache"
    Rails.cache.clear
  end
end
