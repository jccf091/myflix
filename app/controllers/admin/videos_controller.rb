class Admin::VideosController < AdminsController

  def new
    @video = Video.new
  end

  def create
    @video = Video.new(video_params)
    if @video.save
      flash[:success] = "A new video have been created."
      redirect_to new_admin_video_path
    else
      render :new
    end
  end

  private
    def video_params
      params.require(:video).permit(:title, :description, :large_cover_image_url, :small_cover_image_url, :category_id )
    end
end