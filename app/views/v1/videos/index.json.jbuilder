json.items do
  json.array! @videos, partial: "list_video", as: :video
end

json.partial! "common/pagination", pagination: @pagination
