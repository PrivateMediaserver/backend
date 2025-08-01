json.items do
  json.array! @videos, partial: "video", as: :video, full_preview: false, with_file: false
end

json.partial! "common/pagination", pagination: @pagination
