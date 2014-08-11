class VideoWorker
  include Sidekiq::Worker

  def perform
    puts "Doing all the hard work"


  end
end
