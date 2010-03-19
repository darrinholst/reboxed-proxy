desc 'load em up'
task :load_titles => :environment do
  File.open("#{RAILS_ROOT}/lib/titles.js") do |f|
    json = JSON.parse(f.read)

    json.each do |row|
      movie = Movie.new
      movie.id = row['ID']
      movie.name = row['Name']
      movie.sort_name = row['SortName']
      movie.image = row['Img']
      movie.released = Date.parse(row["Release"])
      movie.save
    end
  end
end