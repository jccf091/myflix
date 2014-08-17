require 'carrierwave/orm/activerecord'

class Video < ActiveRecord::Base
  include PgSearch
  include Tokenify

  mount_uploader :cover_image, VideoCoverUploader

  mount_uploader :video_file, VideoFileUploader
  process_in_background :video_file, VideoFileWorker

  belongs_to :category
  has_many :reviews, -> { order('created_at DESC') }
  has_many :queue_items
  validates_presence_of :title, :description,
                        :category
  validates_uniqueness_of :title

  def self.text_search(query)
    rank = <<-RANK
      ts_rank(to_tsvector(title), plainto_tsquery(#{sanitize(query)}))
    RANK
    where("to_tsvector('english', title) @@ :q or
           to_tsvector('english', description) @@ :q", q: query).order("#{rank} desc")
  end

  def to_param
    token
  end

  def total_reviews
    reviews.count
  end

  def decorator
    VideoDecorator.new(self)
  end
end
