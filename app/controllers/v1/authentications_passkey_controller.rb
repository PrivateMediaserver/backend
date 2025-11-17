class V1::AuthenticationsPasskeyController < V1Controller
  def options
    options = WebAuthn::Credential.options_for_get(user_verification: "required")

    render json: { challenge: options.challenge, options: }
  end

  def create
    challenge = params.require(:challenge)
    assertion = params.require(:assertion)

    credential = WebAuthn::Credential.from_get(assertion)
    passkey = Passkey.find_by!(credential_id: Base64.urlsafe_encode64(credential.raw_id))

    credential.verify(
      challenge,
      public_key: passkey.public_key,
      sign_count: passkey.sign_count
    )
    passkey.update!(sign_count: credential.sign_count)

    @authentication = passkey.user.authentications.create(user_agent: request.user_agent)

    render json: { access_token: @authentication.access_token,
                   refresh_token: @authentication.refresh_token }, status: :created
  rescue => e
    render json: { status: 422, error: e.message }, status: :unprocessable_entity
  end
end
