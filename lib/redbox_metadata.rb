class RedboxMetadata
  attr_accessor :url, :token

  def initialize(url)
    self.url = url
    self.token = "l/egA7t7RJiRgezDSAG1tFWhFl/dpmDeHFWjeKws7IM="
    #initialize_token
  end

  def initialize_token
    resp = RestClient.get("http://www.redbox.com")
    self.token = resp.body.match(/__K.*value="(.*)"/)[1]
  end

  def add_to(title)
    puts "adding metadata to #{title.name}(#{title.id})"
    puts token

    postData = "{\"type\":\"Title\",\"pk\":\"ID\",\"statements\":[{\"filters\":{\"ID\":#{title.id}},\"sort\":null,\"flags\":null}],\"__K\":\"l/egA7t7RJiRgezDSAG1tFWhFl/dpmDeHFWjeKws7IM=\"}"
    # postData = JSON.generate({
    #   "type" => "Title",
    #   "pk" => "ID",
    #   "statements" => [{
    #     "filters" => {"ID" => title.id},
    #     "sort" => nil,
    #     "flags" => nil
    #   }],
    #   "__K" => token
    # })

    puts postData

    resp = RestClient.post(url, postData)

    match = /\{.*?\:(.*)\}/.match(resp.body)
    raise "couldn't find metadata in #{resp.body}" unless match

    json = JSON.parse(match[1])

    title.update_attributes({
      :description => json["Desc"] || "Unknown",
      :rating => json["Rating"],
      :running_time => json["RunningTime"],
      :actors => json["Actors"],
      :yahoo_rating => json["YahooRating"],
      :genre => json["Genre"],
      :inv => json["Inv"]
    })
  end
end

=begin
{
   "type":"Title",
   "pk":"ID",
   "statements":[
      {
         "filters":{
            "ID":3098
         },
         "sort":null,
         "flags":null
      }
   ],
   "__K":"UNKNOWN"
}

{
   "d":{
      "ID":3098,
      "Name":"Zombieland",
      "Img":"Zombieland_3098.jpg",
      "QtyRange":0,
      "Buy":"0",
      "Price":7,
      "Rating":"R",
      "RunningTime":"01:28",
      "Actors":"Abigail Breslin, Jesse Eisenberg, Woody Harrelson",
      "YahooRating":"A-",
      "Desc":"Nerdy college student Columbus has survived the plague that has turned mankind into flesh-devouring zombies because he’s scared of just about everything. Gun-toting, Twinkie-loving Tallahassee has no fears. Together, they are about to stare down their most horrifying challenge yet: each other’s company. Emma Stone and Abigail Breslin co-star in this double-hitting, head-smashing comedy.\r\n\r\nRated R by the Motion Picture Association of America for horror violence/gore and language. \r\n\r\nWidescreen.\r\nClosed Captioned.",
      "Genre":"Comedy, Horror, Hit Movies, Top 20 Movies",
      "FormatID":"1",
      "FormatName":"DVD",
      "ProductType":"1",
      "GameInstructionsURL":"",
      "Trailers":{
         "brightcove":"65670378001"
      },
      "Rankings":{
         "Top20RentalsLast7Days":{
            "ProductID":3098,
            "Rank":20,
            "PriorRank":20,
            "Value":120479
         },
         "Top20RentalsLast30Days":{
            "ProductID":3098,
            "Rank":12,
            "PriorRank":10,
            "Value":853804
         }
      },
      "Inv":null
   }
}
=end