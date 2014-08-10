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
    scraping_from_remote
    redirect_to admin_lazy_path
    binding.pry
  end

  private
    def video_params
      params.require(:video).permit(:title, :description, :category_id,
                                    :cover_image, :cover_image_cache,
                                    :remote_cover_image_url)
    end

    def scraping_from_remote
      page = MetaInspector.new(params[:video_imdb_url])
      video = Video.new(title: page.meta_tag["property"]["og:title"],
                description: page.description,
                category_id: params[:category_id])
      video.remote_cover_image_url = page.image
      video.save  
    end
end
