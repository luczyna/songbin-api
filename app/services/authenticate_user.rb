# from https://github.com/pluralsight/guides/blob/master/published/ruby-ruby-on-rails/token-based-authentication-with-ruby-on-rails-5-api/article.md
class AuthenticateUser
  prepend SimpleCommand

  def initialize(email, password)
    @email = email
    @password = password
  end

  def call
    JsonWebToken.encode({user_id: user.id}) if user
  end

  private

  attr_accessor :email, :password

  def user
    user = User.find_by_email(email)
    # return user if user && user.authenticate(password)
    return user if user && user.try(:authenticate, password)

    errors.add :user_authentication, 'invalid credentials'
    nil
  end
end
