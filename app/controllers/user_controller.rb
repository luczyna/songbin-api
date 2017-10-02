class UserController < ApplicationController
  skip_before_action :authenticate_request

  # POST to create a user
  def create
    user = User.new do |u|
      u.name = params[:name]
      u.password = params[:password]
      u.email = params[:email]
    end

    if user.save
      jwt = provide_new_token(user)
      render json: { auth_token: jwt }, status: :created
    else
      # TODO what status to return? 400?
      render json: { error: user.errors }
    end
  end

  private

  def provide_new_token(user)
    AuthenticateUser.call(user.email, user.password).result
  end
end
