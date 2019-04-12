require "jwt"

class JsonWebToken
  def self.encode payload
    payload.reverse_merge! meta
    JWT.encode payload, Rails.application.secrets.secret_key_base
  end

  def self.decode token
    JWT.decode token, Rails.application.secrets.secret_key_base
  end

  def self.valid_payload payload
    return !expired(payload) && payload["iss"] == meta[:iss] && payload["aud"] == meta[:aud]
  end

  def self.meta
    {
      exp: Settings.api.time_reset_token.days.from_now.to_i,
      iss: Settings.api.company,
      aud: Settings.api.client_name,
    }
  end

  def self.expired payload
    Time.at(payload["exp"]) < Time.now
  end
end
