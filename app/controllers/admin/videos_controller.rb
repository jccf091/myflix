class Admin::VideosController < AdminsController

  def new
    @video = Video.new
  end

  def create
    @video = Video.new

    @video.process_video_file_upload = true
    @video.attributes = video_params

    upload_cover_image(@video)
    VideoFileWorker.perform_async(@video.id, params[:video][:remote_video_file_url])
    if @video.save
      flash[:success] = "A new video have been created."
      redirect_to new_admin_video_path
    else
      flash[:warning] = "fail to add video."
      render :new
    end
  end

  #justforfun
  def lazy_add
    LazyWorker.perform_lazy_work_async(params[:genre_imdb_url], params[:category_id])
    flash[:success] = "Added."
    redirect_to admin_lazy_path
  end

  private
    def video_params
      params.require(:video).permit(:title, :description, :category_id)
    end

    def upload_cover_image(video)
      unless params[:video][:remote_cover_image_url].blank?
        video.remote_cover_image_url = params[:video][:remote_cover_image_url]
      else
        video.cover_image = params[:video][:cover_image]
      end
      video.save
    end


end
