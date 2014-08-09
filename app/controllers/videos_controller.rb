class VideosController < ApplicationController
  before_action :set_video, only: [:show]
  before_action :require_signed_in_user

  def index
    @categories = Category.all
  end

  def show
    @reviews = @video.reviews
  end

  private
    def set_video
      @video = Video.find_by(token: params[:id])
    end
end
