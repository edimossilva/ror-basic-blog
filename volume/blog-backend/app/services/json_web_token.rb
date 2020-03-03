class JsonWebToken
  # EDITOR=nano rails credentials:edit a667717bf0a47475b0582547379c816d
  SECRET_KEY = Rails.application.credentials.jwt[:secret_key]
  def self.encode(payload, exp = 24.hours.from_now)
    payload[:exp] = exp.to_i
    JWT.encode(payload, SECRET_KEY)
  end

  def self.decode(token)
    decoded = JWT.decode(token, SECRET_KEY)[0]
    HashWithIndifferentAccess.new decoded
  end
end