class LazyWorker
  include Sidekiq::Worker

  def perform(link, category_id)
    puts 'Doing all the lazy work'

    links = MetaInspector.new(link).internal_links

    links.reverse_each do |link|
      begin
        unless link.to_s.include?("http://www.imdb.com/title")
          next
        end
        page = MetaInspector.new(link, :timeout => 5)
        next if page.nil?
        video = Video.new(title: page.meta_tag["property"]["og:title"],
                  description: page.description,
                  category_id: category_id)
        video.remote_cover_image_url = page.image
        page.internal_links.each do |link|
          if link.to_s.include?("http://www.imdb.com/video/imdb/")
            
            break
          end
        end
        video.save
      rescue => e
        e.message
      end
    end

    puts "Done"
  end
end
