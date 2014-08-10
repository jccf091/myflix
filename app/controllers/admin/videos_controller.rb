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
    scraping_from_imdb_genre
    flash[:success] = "Added."

    redirect_to admin_lazy_path
  end

  private
    def video_params
      params.require(:video).permit(:title, :description, :category_id,
                                    :cover_image, :cover_image_cache,
                                    :remote_cover_image_url)
    end

    ###justforfun
    def scraping_from_imdb_genre
      links = MetaInspector.new(params[:genre_imdb_url]).internal_links

      links.each do |link|
        begin
          unless link.to_s.include?("http://www.imdb.com/title")
            puts "Skiping..."
            next
          end
          page = MetaInspector.new(link, :timeout => 5)
          next if page.nil?

          if identify_moive(page)
            video = Video.new(title: page.meta_tag["property"]["og:title"],
                      description: page.description,
                      category_id: params[:category_id])
            video.remote_cover_image_url = page.image
            video.save
          end
        rescue => e
          e.message
        end
      end
    end

    def identify_moive(page)
      return false if page.meta_tags["property"]["og:type"].nil?
      page.meta_tags["property"]["og:type"][0].to_s == "video.movie"
    end
end
