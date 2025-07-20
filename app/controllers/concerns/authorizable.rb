module Authorizable
  extend ActiveSupport::Concern

  included do
    private

    def authorize
      Current.authentication_id = payload&.fetch("jti")
      Current.user = User.find_by(id: payload&.fetch("sub"))

      render json: { status: 401, error: "Unauthorized" }, status: :unauthorized unless Current.user
    end

    def payload
      ApplicationJwt.decode(authorization_token)
    rescue
      nil
    end

    def authorization_token
      type, token = authorization_header.split(" ")

      type == "Bearer" ? token : nil
    end

    def authorization_header
      request.headers["Authorization"]
    end
  end
end
