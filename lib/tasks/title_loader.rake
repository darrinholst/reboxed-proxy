desc 'load em up'
task :load_titles => :environment do
  File.open("#{RAILS_ROOT}/lib/titles.js") do |f|
    json = JSON.parse(f.read)

    json.each do |row|
      title = Title.new
      title.id = row['ID']
      title.name = row['Name']
      title.sort_name = row['SortName']
      title.image = row['Img']
      title.released = Date.parse(row['Release'])
      title.product_type = row['ProductType']
      title.save
    end
  end
end