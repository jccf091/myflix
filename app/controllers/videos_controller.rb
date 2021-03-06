class VideosController < ApplicationController
  before_action :require_signed_in_user

  def index
    @categories = Category.first(30)
  end

  def show
    @video = Video.find_by(token: params[:id])
    @reviews = @video.reviews
  end

end
