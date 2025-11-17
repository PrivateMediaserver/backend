class V1::AuthenticationsController < V1Controller
  before_action :authorize, only: %i[index destroy terminate]
  before_action :set_authentication_by_refresh_token, only: %i[refresh]
  before_action :set_authentication, only: %i[terminate]

  def index
    @authentications = Current.user.authentications.order(updated_at: :desc)
  end

  def refresh
    if @authentication
      @authentication.update(refresh_uuid: SecureRandom.uuid_v7,
                             user_agent: request.user_agent,
                             last_active_at: Time.now)

      render json: { access_token: @authentication.access_token,
                     refresh_token: @authentication.refresh_token }
    else
      render json: { status: 401, error: "Unauthorized" }, status: :unauthorized unless @authentication
    end
  end

  def destroy
    Authentication.active.find(Current.authentication_id).inactive!
  end

  def terminate
    @authentication.inactive!
  end

  private

  def set_authentication_by_refresh_token
    @authentication = Authentication.active.find_by(refresh_uuid:)
  end

  def set_authentication
    @authentication = Authentication.active.find(params.expect(:id))
  end

  def refresh_uuid
    ApplicationJwt.decode(refresh_token).fetch("sub")
  rescue
    nil
  end

  def refresh_token
    params.expect(:refresh_token)
  end
end
