class Ffmpeg
  DEFAULT_SCREENSHOT_COUNT = 36

  def initialize(video_path, uuid)
    @video_path = video_path
    @uuid       = uuid
  end

  def info
    return @info if @info

    command = [
      ffprobe_path,
      @video_path,
      "-hide_banner",
      "-print_format", "json",
      "-show_format",
      "-show_streams",
      "-show_error"
    ]
    output = Open3.popen3(*command) { |_stdin, stdout, _stderr| stdout.read.to_s }

    @info = JSON.parse(output, symbolize_names: true)
  end

  def generate_frames(count = DEFAULT_SCREENSHOT_COUNT)
    Dir.mkdir(directory) unless Dir.exist?(directory)

    fps_value = "fps=#{count.to_f / duration}"
    output_pattern = File.join(directory, "%03d.png")

    Open3.popen3(
      ffmpeg_path,
      "-hide_banner",
      "-y",
      "-i", @video_path,
      "-vf", fps_value,
      "-frames:v", count.to_s,
      output_pattern
    )

    Open3.popen3(*command) { }

    @screenshots = Dir[File.join("/tmp", @uuid, "*.png")].sort
  end

  def cleanup
    FileUtils.rm_r(directory) if Dir.exist?(directory)
  end

  private

  def directory
    "/tmp/#{@uuid}"
  end

  def duration
    info.dig(:streams, 0, :duration).to_f
  end

  def ffmpeg_path
    "ffmpeg"
  end

  def ffprobe_path
    "ffprobe"
  end
end
