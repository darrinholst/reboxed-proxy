class MoviesController < ApplicationController
  def index
    date = Chronic.parse(params[:since] || "8/5/76")
    @movies = Title.oldest.movies.since(date).find(:all, :limit => 250)

    respond_to do |format|
      format.json {render :json => @movies.to_json(:only => [
        :id,
        :name,
        :image,
        :released,
        :description,
        :rating,
        :running_time,
        :actors,
        :genre,
        :yahoo_rating
      ])}
    end
  end
end
