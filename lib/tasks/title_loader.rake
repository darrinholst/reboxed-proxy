desc 'load titles'
task :load_titles => :environment do
  RedboxSlurper.slurp_titles_from("http://www.redbox.com/data.svc/Title/js");
end