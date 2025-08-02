module Ffmpeg
  private

  def run_command(cmd_array)
    stdout, stderr, status = Open3.capture3(cmd_array.join(" "))
    raise "command execution error: #{stderr}" unless status.success?
  end

  def ffmpeg_path
    "ffmpeg"
  end

  def ffprobe_path
    "ffprobe"
  end
end
