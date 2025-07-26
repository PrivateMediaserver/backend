class ProcessVideoJob < ApplicationJob
  queue_as :low

  def perform(id)
    @video = Video.find(id)
    create_screenshots
  end

  private

  def create_screenshots
    @video.file.open do |file|
      @video.screenshots.destroy_all unless @video.unprocessed?

      @video.processing!

      ffmpeg = Ffmpeg.new(file.path, @video.id)
      screenshots = ffmpeg.generate_frames

      screenshots.each_with_index do |s, i|
        screenshot = @video.screenshots.create(main: i == 0)
        screenshot.file.attach(io: File.open(s), filename: "#{i + 1}.png", content_type: "image/png")
      end

      ffmpeg.cleanup

      @video.processed!
    end
  end
end
