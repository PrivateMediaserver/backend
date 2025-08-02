module Ffmpeg
  class Video
    attr_reader :storage

    def initialize(video_path, uuid)
      @storage = Ffmpeg::Storage.new(video_path, uuid)
    end

    def duration
      info.dig(:streams, 0, :duration).to_f
    end

    def width
      info.dig(:streams, 0, :width).to_i
    end

    def height
      info.dig(:streams, 0, :height).to_i
    end

    def generate_hls
      hls = Ffmpeg::Hls.new(@storage)
      hls.generate
    end

    def generate_frameset
      frameset = Ffmpeg::FrameSet.new(@storage)
      frameset.generate
    end

    def cleanup
      @storage.cleanup
    end

    private

    def info
      @info ||= Ffmpeg::Info.new(@storage).show
    end
  end
end
