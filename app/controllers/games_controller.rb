class GamesController < ApplicationController
  def index
    date = Chronic.parse(params[:since] || "8/5/76")
    cache_key = date.strftime("%Y%m%d")
    cached = Rails.cache.read(cache_key)

    unless(cached)
      games = Title.oldest.games.since(date).find(:all, :limit => 200)
      cached = games.to_json(:only => [:id, :name, :image, :released, :description, :rating])
      Rails.cache.write(cache_key, cached)
    end

    render :json => cached
  end
end
