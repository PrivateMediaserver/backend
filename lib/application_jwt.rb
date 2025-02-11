class ApplicationJwt
  class << self
    def encode(payload, exp)
      JWT.encode({ **payload, exp:, nbf:, iss:, iat: nbf }, hmac_secret, algorithm, { typ: })
    end

    def decode(token)
      token = JWT.decode(token, hmac_secret, true, { algorithm:, iss: })
      token[0]
    end

    private

    def nbf
      Time.now.to_i
    end

    def iss
      "MediaServer"
    end

    def typ
      "JWT"
    end

    def algorithm
      "HS512"
    end

    def hmac_secret
      ENV.fetch("JWT_SECRET")
    end
  end
end
