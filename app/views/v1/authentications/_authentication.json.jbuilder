json.extract! authentication, :id, :status, :last_active_at, :created_at, :updated_at
json.current authentication.id == Current.authentication_id

browser = Browser.new(authentication.user_agent)

json.user_agent do
  json.type browser.device.mobile? ? "mobile" : "other"
  json.browser_name browser.name
  json.browser_version browser.version
end
