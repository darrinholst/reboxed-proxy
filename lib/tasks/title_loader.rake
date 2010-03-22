desc 'load titles'
task :load_titles => :environment do
  RedboxSlurper.new("http://www.redbox.com/data.svc/Title/js").slurp_titles;
end
