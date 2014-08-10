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

  #justforfun
  def lazy_add
    ImageCoverWorker.perform_async(params[:genre_imdb_url], params[:category_id])
    flash[:success] = "Added."

    redirect_to admin_lazy_path
  end

  private
    def video_params
      params.require(:video).permit(:title, :description, :category_id,
                                    :cover_image, :cover_image_cache,
                                    :remote_cover_image_url)
    end

end
