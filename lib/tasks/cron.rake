TITLES_URL = "http://www.redbox.com/data.svc/Title/js"
METADATA_URL = "http://www.redbox.com/data.svc/Title"

task :cron => :environment do
  puts RestClient.get("http://reboxed.semicolonapps.com")

  if Time.now.hour % 4 == 0
    puts "Time to slurp"

    if RedboxSlurper.new(TITLES_URL, METADATA_URL).slurp_titles > 0
      puts "clearing cache"
      Rails.cache.clear
    end
  end
end