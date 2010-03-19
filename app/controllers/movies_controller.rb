class MoviesController < ApplicationController
  def index
    @movies = Movie.find(:all)

    respond_to do |format|
      format.json {render :json => @movies.to_json(:only => [:id, :name, :image, :released])}
    end
  end
end
