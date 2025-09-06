json.extract! video, :id, :name, :duration, :width, :height, :status, :created_at, :updated_at

json.preview polymorphic_url(video.preview.file.variant(:webp))
json.file playlist

json.tags do
  json.array! video.tags, partial: "v1/tags/tag", as: :tag
end

json.people do
  json.array! video.people, partial: "v1/people/person", as: :person
end
