class MetaController < ApplicationController
  def index
    render :json => {:movies => {:count => Title.movies.count}, :games => {:count => Title.games.count}}.to_json
  end
end
