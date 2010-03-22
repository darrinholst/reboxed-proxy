task :cron => :environment do
  metadata = RedboxMetadata.new("http://www.redbox.com/data.svc/Title")

  20.times do
    title = Title.empty_metadata.find(:first)
    metadata.add_to(title) if title
  end
end