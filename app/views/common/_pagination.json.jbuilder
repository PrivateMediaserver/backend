# json.extract! pagination
json.meta do
  json.count pagination.count
  json.limit pagination.limit
  json.page pagination.page
  json.pages pagination.last
end
