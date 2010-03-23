class MoviesController < ApplicationController
  def index
    @movies = Title.most_recent.movies.find(:all, :limit => 100)

    respond_to do |format|
      format.json {render :json => @movies.to_json(:only => [:id, :name, :image, :released, :description, :rating, :running_time, :actors, :genre, :yahoo_rating])}
    end
  end
end
