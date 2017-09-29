# from https://github.com/pluralsight/guides/blob/master/published/ruby-ruby-on-rails/token-based-authentication-with-ruby-on-rails-5-api/article.md
class AuthorizeApiRequests
  prepend SimpleCommand

  def initialize(headers = {})
    @headers = headers
  end

  def call
    user
  end
  
  private

  attr_reader :headers

  def decoded_auth_token
    @decoded_auth_token ||= JsonWebToken.decode(http_auth_header)
  end

  def http_auth_header
    if headers[:Authorization].present?
      return headers[:Authorization].split(' ').last
    else
      errors.add(:token, 'Missing token')
    end

    nil
  end

  def user
    @user ||= User.find(decoded_auth_token[:user_id]) if decoded_auth_token
    @user || errors.add(:token, 'Invalid token') && nil
  end
end
