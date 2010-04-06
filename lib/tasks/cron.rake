TITLES_URL = "http://www.redbox.com/data.svc/Title/js"
METADATA_URL = "http://www.redbox.com/data.svc/Title"

task :cron => :environment do
  puts RestClient.get("http://reboxed.semicolonapps.com")

  if RedboxSlurper.new(TITLES_URL, METADATA_URL).slurp_titles > 0
    puts "clearing cache"
    Rails.cache.clear
  end
end