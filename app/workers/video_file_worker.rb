class VideoFileWorker < ::CarrierWave::Workers::ProcessAsset

  def perform(video_id, url)
    video = Video.find(video_id)
    video.remote_video_file_url = url
    video.save
    puts "Done."
  end

  def error(job, exception)
    report_job_failure  # or whatever
  end
end
