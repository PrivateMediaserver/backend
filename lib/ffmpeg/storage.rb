module Ffmpeg
  class Storage
    attr_reader :video

    def initialize(original_video_path, uuid)
      @video = original_video_path
      @uuid = uuid

      FileUtils.mkdir_p(hls_dir) unless Dir.exist?(hls_dir)
      FileUtils.mkdir_p(screenshots_dir) unless Dir.exist?(screenshots_dir)
    end

    def hls_dir
      File.join(tmp_dir, "fragments")
    end

    def hls_playlist_path
      File.join(hls_dir, Ffmpeg::Hls.playlist_name)
    end

    def hls_fragment_name_pattern_path
      File.join(hls_dir, Ffmpeg::Hls.fragment_name_pattern)
    end

    def screenshots_dir
      File.join(tmp_dir, "screenshots")
    end

    def screenshots_name_pattern_path
      File.join(screenshots_dir, Ffmpeg::FrameSet.name_pattern)
    end

    def stored_screenshots
      Dir[File.join(screenshots_dir, "*.png")].sort
    end

    def cleanup
      FileUtils.rm_r(tmp_dir) if Dir.exist?(tmp_dir)
    end

    private

    def tmp_dir
      File.join("/tmp", @uuid)
    end
  end
end
