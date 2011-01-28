module Net::HTTPHeader
  def capitalize(name)
    return "__K" if name.eql? "__k"
    name.split(/-/).map {|s| s.capitalize }.join('-')
  end
end

task :cron => :environment do
  if Redbox.new.sync > 0
    p "clearing cache"
    Rails.cache.clear
  end
end
