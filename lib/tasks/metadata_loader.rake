desc 'load metadata'
task :load_metadata => :environment do
  title = Title.empty_metadata.find(:first)
  RedboxMetadata.new("http://www.redbox.com/data.svc/Title").add_to(title) if title
end