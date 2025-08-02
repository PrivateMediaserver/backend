json.extract! video, :id, :name, :duration, :width, :height, :status, :created_at, :updated_at

if video.preview&.file
  json.preview polymorphic_url(video.preview.file.variant(full_preview ? :avif : :thumb))
else
  json.preview nil
end

if with_file
  json.file @playlist
end
