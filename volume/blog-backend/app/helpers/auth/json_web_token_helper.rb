module Auth
  module JsonWebTokenHelper
    SECRET_KEY = Rails.application.credentials.jwt[:secret_key]

    def encode_user(user, exp = 24.hours.from_now)
      payload = {}
      payload[:exp] = exp.to_i
      payload[:user_id] = user.id

      JWT.encode(payload, SECRET_KEY)
    end

    def decode_token(token)
      decoded = JWT.decode(token, SECRET_KEY)[0]
      HashWithIndifferentAccess.new decoded
    end

    def header_for_user(user)
      { 'Authorization' => encode_user(user) }
    end
  end
end
