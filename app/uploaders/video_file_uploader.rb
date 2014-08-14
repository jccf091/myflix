# encoding: utf-8

class VideoFileUploader < CarrierWave::Uploader::Base

  include ::CarrierWave::Backgrounder::Delay
  storage :fog

  def store_dir
    if Rails.env.production?
      "production/uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
    else
      "development/uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
    end
  end
end
