module Ffmpeg
  class FrameSet
    include Ffmpeg

    DEFAULT_SCREENSHOT_COUNT = 36

    def initialize(storage)
      @storage = storage
    end

    def generate(count = DEFAULT_SCREENSHOT_COUNT)
      return @storage.stored_screenshots unless @storage.stored_screenshots.empty?

      fps_value = count.to_f / duration

      command = [
        ffmpeg_path,
        "-hide_banner",
        "-y",
        "-i", @storage.video,
        "-vf", "fps=#{fps_value}",
        "-frames:v", count.to_s,
        @storage.screenshots_name_pattern_path
      ]

      run_command(command)

      @storage.stored_screenshots
    end

    private

    def duration
      info.dig(:duration).to_f
    end

    def info
      @info ||= Ffmpeg::Info.new(@storage).video_stream
    end

    class << self
      def name_pattern
        "%03d.png"
      end
    end
  end
end
