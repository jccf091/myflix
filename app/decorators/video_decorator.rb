class VideoDecorator
  extend Forwardable

  def_delegators :video, :to_params, :total_reviews

  attr_reader :video
  def initialize(video)
    @video = video
  end

  def display_rating
    rating ? "#{rating}/5.0" : "N/A"
  end

  private
    def rating
      video.reviews.average(:rating).round(1) if video.reviews.average(:rating)
    end
end
