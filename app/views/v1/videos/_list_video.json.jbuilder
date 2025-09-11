json.extract! video, :id, :name, :duration, :progress, :width, :height, :status, :created_at, :updated_at

json.preview polymorphic_url(video.preview.file.variant(:thumb))
