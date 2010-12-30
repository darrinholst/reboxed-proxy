class RedboxSlurper
  attr_accessor :url, :metadata

  def initialize(url, metadata_url)
    self.url = url
    self.metadata = RedboxMetadata.new(metadata_url)
  end

  def slurp_titles
    puts "getting #{url}"
    resp = RestClient.get(url, :cookies => {"RB_2.0" => "1"})

    match = /=\ *(\[.*\])/.match(resp.body)
    raise "couldn't find movies in #{resp.body}" unless match

    json = JSON.parse(match[1])
    puts "found #{json.length} movies"
    new_movies = 0

    json.each_with_index do |row, i|
      if(new_movies < 5)
      if(row["releaseDays"].to_i >= -14)
        begin
          Title.find(row["ID"])
        rescue ActiveRecord::RecordNotFound => e
          title = Title.new
          title.id = row['ID']
          title.name = row['name']
          title.sort_name = row['sortName']
          title.image = row['img']
          title.released = Date.parse(row['release'])
          title.product_type = row['productType']
          puts("adding #{title.name}")
          title.save
          metadata.add_to(title)
          new_movies += 1
        end
      end
      end
    end

    new_movies
  end
end
