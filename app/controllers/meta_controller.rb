class MetaController < ApplicationController
  def index
    render :json => {:movies => {:count => Title.movies.count}}.to_json
  end
end
