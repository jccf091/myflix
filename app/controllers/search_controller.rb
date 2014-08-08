class SearchController < ApplicationController

  def index
    keyword = params[:search].strip

    if video = Video.find_by(title: keyword.titleize)
      redirect_to video
    else
      @results = Video.search(keyword)
    end
  end
end
