module Ffmpeg
  class Info
    include Ffmpeg

    def initialize(storage)
      @storage = storage
    end

    def video_stream
      streams[:streams].find { |s| s[:codec_type] == "video" }
    end

    private

    def streams
      return @info if @info

      command = [
        ffprobe_path,
        @storage.video,
        "-hide_banner",
        "-print_format", "json",
        "-show_format",
        "-show_streams",
        "-show_error"
      ]
      output = Open3.popen3(*command) { |_stdin, stdout, _stderr| stdout.read.to_s }

      @info = JSON.parse(output, symbolize_names: true)
    end
  end
end
