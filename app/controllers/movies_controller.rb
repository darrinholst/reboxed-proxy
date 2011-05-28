class MoviesController < ApplicationController
  def index
    date = Chronic.parse(params[:since] || "8/5/76")
    #cache_key = "movies" + date.strftime("%Y%m%d")
    #cached = Rails.cache.read(cache_key)

    #unless(cached)
      movies = Title.oldest.movies.since(date).find(:all, :limit => 200)
      cached = movies.to_json(:only => [:id, :name, :image, :released, :description, :rating, :running_time, :actors, :genre, :yahoo_rating])
      #Rails.cache.write(cache_key, cached)
    #end

    render :json => cached
  end
end
