class SearchController < ApplicationController
  before_action :require_signed_in_user

  def index
    keyword = params[:search].strip

    if jump = find_jump_target(keyword)
      redirect_to jump
    else
      @results = Video.text_search(keyword).first(30)
    end
  end

  private
    def find_jump_target(keyword)
      Video.find_by(title: keyword.titleize) ||
      User.find_by(full_name: keyword)
    end
end
