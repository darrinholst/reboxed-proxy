class MoviesController < ApplicationController
  def index
    @movies = Title.movies.find(:all)

    respond_to do |format|
      format.json {render :json => @movies.to_json(:only => [:id, :name, :image, :released, :description, :rating, :running_time, :actors, :genre])}
    end
  end
end
