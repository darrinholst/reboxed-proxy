#TITLES_URL = "http://www.redbox.com/data.svc/Title/js"
#METADATA_URL = "http://www.redbox.com/data.svc/Title"

TITLES_URL = "http://www.redbox.com/api/product/js/__titles"
METADATA_URL = "http://www.redbox.com/api/Product/GetDetail/"

task :cron => :environment do
  if RedboxSlurper.new(TITLES_URL, METADATA_URL).slurp_titles > 0
    puts "clearing cache"
    Rails.cache.clear
  end
end
