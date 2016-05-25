require "jwt"

class TokenManager
  class << self
    def generate_token(user_id, exp = 24.hours.from_now, notify_object = nil)
      payload = { user: user_id, exp: exp.to_i }
      payload = { object: notify_object, exp: exp.to_i } if notify_object
      issue_token(payload)
    end

    def issue_token(payload)
      JWT.encode(payload, secret, "HS512")
    end

    def secret
      Rails.application.secrets.secret_key_base
    end

    def decode(token)
      JWT.decode(token, secret, true, algorithm: "HS512")
    end

    def authenticate(token)
      decode(token).first
    rescue
      {}
    end
  end
end
