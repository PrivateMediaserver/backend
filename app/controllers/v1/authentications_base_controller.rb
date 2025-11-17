class V1::AuthenticationsBaseController < V1Controller
  def create
    email, password = authentication_params
    user = User.find_by(email:)

    if user&.authenticate(password)
      @authentication = user.authentications.create(user_agent: request.user_agent)

      render json: { access_token: @authentication.access_token,
                     refresh_token: @authentication.refresh_token }, status: :created
    else
      render json: { status: 401, error: "Unauthorized" }, status: :unauthorized
    end
  end

  private

  def authentication_params
    params.expect(:email, :password)
  end
end
