class Authentication < ApplicationRecord
  belongs_to :user

  enum :status, inactive: 0, active: 1, revoked: 10

  before_create :set_refresh_uuid

  def access_token
    ApplicationJwt.encode({ sub: user_id, jti: id  }, nbf + 5.minutes.to_i)
  end

  def refresh_token
    ApplicationJwt.encode({ sub: refresh_uuid  }, nbf + 6.hour.to_i)
  end

  private

  def set_refresh_uuid
    self.refresh_uuid = SecureRandom.uuid_v7
  end

  def nbf
    updated_at.to_i
  end
end
