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

  pg_search_scope :search,
                  :against => [:title, :description],
                  :using => {
                    :tsearch => {
                      :prefix => true, :dictionary => "english", :any_word => true
                    },
                    :trigram => {
                      :threshold => 0.5,
                      :only => [:title]
                    },
                    :dmetaphone => {
                      :any_word => true
                    }
                  }
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
