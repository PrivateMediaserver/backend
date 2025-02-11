json.extract! authentication, :id, :status, :user_agent, :created_at, :updated_at
json.current authentication.id == Current.authentication_id
