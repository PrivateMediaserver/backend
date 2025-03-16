class ProcessVideoJob < ApplicationJob
  queue_as :default

  def perform(id)
    @video = Video.find(id)
    @video.processing!

    create_screenshots
  end

  private

  def create_screenshots
    ffmpeg = Ffmpeg.new(file_path, @video.id)
    screenshots = ffmpeg.generate_frames

    screenshots.each_with_index do |s, i|
      screenshot = @video.screenshots.create(main: i == 0)
      screenshot.file.attach(io: File.open(s), filename: "#{i + 1}.png", content_type: "image/png")
    end

    ffmpeg.cleanup

    @video.processed!
  end

  def file_path
    original_filename = @video.file.blob.filename
    temporary_file = Tempfile.new([ original_filename.base, ".#{original_filename.extension}" ], binmode: true)
    temporary_file.write(@video.file.download)

    temporary_file.path
  end
end
