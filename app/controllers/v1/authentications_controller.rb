class V1::AuthenticationsController < V1Controller
  before_action :authorize, only: %i[index destroy terminate]
  before_action :set_authentication_by_refresh_token, only: %i[refresh]
  before_action :set_authentication, only: %i[terminate]

  def index
    @authentications = Current.user.authentications.order(updated_at: :desc)
  end

  def create
    email, password = authentication_params
    user = User.find_by(email:)

    if user&.authenticate(password)
      @authentication = user.authentications.create(user_agent:)
    else
      render json: { status: 401, error: "Unauthorized" }, status: :unauthorized
    end
  end

  def refresh
    if @authentication
      @authentication.update(refresh_uuid: SecureRandom.uuid_v7, user_agent:)
      render :create, status: :created
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

  def authentication_params
    params.expect(:email, :password)
  end

  def refresh_token
    params.expect(:refresh_token)
  end

  def user_agent
    request.user_agent
  end
end
