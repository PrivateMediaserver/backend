json.extract! video, :id, :name, :status, :created_at, :updated_at

metadata = video.file.blob.metadata

if metadata
  json.width metadata[:width]
  json.height metadata[:height]
  json.duration metadata[:duration]
else
  json.width nil
  json.height nil
  json.duration nil
end

if video.preview&.file
  json.preview polymorphic_url(video.preview.file.variant(full_preview ? :webp : :thumb))
else
  json.preview nil
end

if with_file
  json.file video.file.url(expires_in: 1.hour)
end
