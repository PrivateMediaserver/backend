module Ffmpeg
  class Video
    attr_reader :storage

    def initialize(video_path, uuid)
      @storage = Ffmpeg::Storage.new(video_path, uuid)
    end

    def duration
      info&.dig(:duration).to_f
    end

    def width
      info&.dig(:width).to_i
    end

    def height
      info&.dig(:height).to_i
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
      @info ||= Ffmpeg::Info.new(@storage).video_stream
    end
  end
end
