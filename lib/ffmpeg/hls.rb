module Ffmpeg
  class Hls
    include Ffmpeg

    def initialize(storage)
      @storage = storage
    end

    def generate
      command = [
        ffmpeg_path,
        "-hide_banner",
        "-y",
        "-i",
        @storage.video,
        "-c copy",
        "-start_number 0",
        "-hls_time 4",
        "-hls_list_size 0",
        "-f hls",
        "-hls_segment_filename", @storage.hls_fragment_name_pattern_path,
        @storage.hls_playlist_path
      ]

      run_command(command)

      {
        headers:,
        fragments:
      }
    end

    def headers
      header_lines = []

      playlist_lines.each do |line|
        break if line.start_with?("#EXTINF:")
        header_lines << line
      end

      header_lines
    end

    def fragments
      return @fragments if @fragments

      @fragments = []

      playlist_lines.each_with_index do |line, i|
        next unless line.start_with?("#EXTINF:")

        duration = line.sub("#EXTINF:", "").sub(",", "").to_f
        filename = playlist_lines[i + 1]

        @fragments.push({ duration:,
                          path: File.join(@storage.hls_dir, filename) })
      end

      @fragments
    end

    private

    def playlist_lines
      @playlist_lines ||= File.readlines(@storage.hls_playlist_path).map(&:strip)
    end

    class << self
      def playlist_name
        "playlist.m3u8"
      end

      def fragment_name_pattern
        "fragment_%03d.ts"
      end
    end
  end
end
