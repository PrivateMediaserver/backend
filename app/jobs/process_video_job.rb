class ProcessVideoJob < ApplicationJob
  queue_as :low

  def perform(id)
    @video = Video.find(id)

    unless @video.unprocessed?
      @video.video_fragments.destroy_all
      @video.screenshots.destroy_all
    end

    @video.processing!

    @video.file.open do |file|
      processor = Ffmpeg::Video.new(file.path, @video.id)

      generate_fragments(processor)
      generate_screenshots(processor)

      processor.cleanup
    end

    @video.file.destroy
    @video.processed!
  end

  private

  def generate_fragments(processor)
    playlist = processor.generate_hls

    @video.update(headers: playlist[:headers],
                  duration: processor.duration,
                  width: processor.width,
                  height: processor.height)

    playlist[:fragments].each_with_index do |fragment, index|
      model = @video.video_fragments.create(sequence_number: index, duration: fragment[:duration])
      model.file.attach(io: File.open(fragment[:path]), filename: File.basename(fragment[:path]))
    end
  end

  def generate_screenshots(processor)
    screenshots = processor.generate_frameset

    screenshots.each_with_index do |s, i|
      screenshot = @video.screenshots.create(main: i == 0)
      screenshot.file.attach(io: File.open(s), filename: "#{i + 1}.png", content_type: "image/png")
    end
  end
end
