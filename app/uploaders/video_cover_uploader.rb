# encoding: utf-8

class VideoCoverUploader < CarrierWave::Uploader::Base

  include CarrierWave::MiniMagick


  storage :fog
  def store_dir
    if Rails.env.production?
      "production/uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
    else
      "develoopment/uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
    end
  end

  def cache_dir
    '/tmp/projectname-cache'
  end

  def extension_white_list
    %w(jpg jpeg gif png)
  end

  version :large_cover do
    process :resize_to_fill => [472.5, 700] #1 : 0.675
  end

  version :small_cover do
    process :resize_to_fill => [202.5, 300] #1 : 0.675
  end
end
