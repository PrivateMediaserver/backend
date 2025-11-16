class V1::PasskeysController < V1Controller
  before_action :authorize
  before_action :set_passkey, only: [ :show ]

  def index
    @passkeys = Current.user.passkeys
  end

  def show
  end

  def options
    options = options_for_create

    # TODO: add expiration
    Rails.cache.write(options_cache_key, Base64.urlsafe_encode64(options.challenge))
    render json: options, status: :created
  end

  def create
    challenge = Rails.cache.read(options_cache_key)
    raise "No challenge" if challenge.blank? # TODO: use i18n

    attestation = params.require(:attestation)
    credential = WebAuthn::Credential.from_create(attestation)
    credential.verify(Base64.urlsafe_decode64(challenge))

    @passkey = Current.user.passkeys.create(
      credential_id: Base64.urlsafe_encode64(credential.raw_id),
      public_key: credential.public_key,
      sign_count: credential.sign_count,
      name: "Replace me"
    )

    render :show, status: :created
  rescue => e
    render json: { status: 422, error: e.message }, status: :unprocessable_entity
  end

  private

  def set_passkey
    @passkey = Current.user.passkeys.find(params.expect(:id))
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

  def options_cache_key
    "webauthn_options_#{Current.user.id}"
  end
end
