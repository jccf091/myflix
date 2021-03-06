CarrierWave.configure do |config|
  config.fog_credentials = {
    :provider               => 'AWS',
    :aws_access_key_id      => ENV["aws_access_key_id"],
    :aws_secret_access_key  => ENV["aws_secret_access_key"],
    :region                 => 'ap-northeast-1'
  }
  config.fog_directory  = ENV["aws_s3_bucket"]                  # required
  config.fog_public     = false                                   # optional, defaults to true
  config.fog_attributes = {'Cache-Control'=>'max-age=315576000'}  # optional, defaults to {}
end
