class RedboxSlurper
  attr_accessor :url

  def initialize(url)
    self.url = url;
  end

  def slurp_titles
    puts "getting #{url}"
    resp = RestClient.get(url)

    match = /=\ *(\[.*\]);/.match(resp.body)
    raise "couldn't find movies in #{resp.body}" unless match

    json = JSON.parse(match[1])
    puts "found #{json.length} movies"

    json.each do |row|
      begin
        Title.find(row["ID"])
      rescue ActiveRecord::RecordNotFound => e
        title = Title.new
        title.id = row['ID']
        title.name = row['Name']
        title.sort_name = row['SortName']
        title.image = row['Img']
        title.released = Date.parse(row['Release'])
        title.product_type = row['ProductType']
        puts("adding #{title.name}")
        title.save
      end
    end
  end
end