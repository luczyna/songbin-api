# from https://github.com/pluralsight/guides/blob/master/published/ruby-ruby-on-rails/token-based-authentication-with-ruby-on-rails-5-api/article.md
class JsonWebToken
  class << self
    def encode(payload, expiration = 24.hours.from_now)
      payload[:exp] = expiration.to_i
      JWT.encode(payload, Rails.application.secrets.secret_key_base, 'none')
    end

    def decode(token)
      body = JWT.decode(token, Rails.application.secrets.secret_key_base, false)[0]
      HashWithIndifferentAccess.new body
    rescue
      nil
    end
  end
end
