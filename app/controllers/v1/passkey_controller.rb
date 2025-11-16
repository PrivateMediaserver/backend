class V1::PasskeyController < V1Controller
  before_action :authorize

  def options
    options = options_for_create
    Rails.cache.write(options_cache_key, options.challenge) # TODO: add expiration

    render json: options, status: :created
  end

  def create
    challenge = Rails.cache.read(options_cache_key)
    raise "No challenge" if challenge.blank? # TODO: use i18n

    credential = WebAuthn::Credential.from_create(params.require(:attestation))

    credential.verify(challenge)

    @passkey = Current.user.create_passkey(
      credential_id: Base64.urlsafe_encode64(credential.raw_id),
      public_key: credential.public_key,
      sign_count: credential.sign_count,
    )
  end

  private

  def options_cache_key
    "webauthn_token_creation_options:#{Current.user.id}"
  end

  def options_for_create
    WebAuthn::Credential.options_for_create(
      user: {
        id: Current.user.id,
        name: Current.user.email
      },
      authenticator_selection: {
        resident_key: "required",
        user_verification: "required"
      },
      attestation: "none"
    )
  end
end
