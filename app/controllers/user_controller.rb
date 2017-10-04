class UserController < ApplicationController
  skip_before_action :authenticate_request, only: :create

  rescue_from ActiveRecord::RecordNotFound do
    render json: { error: "Can't find that user, try again" }, :status => :not_found
  end

  rescue_from ActionController::ParameterMissing do
    render json: {
      error: "Malformed request! Please refer to the documentation and try again"
    }, :status => :bad_request
  end

  # POST to create a user
  def create
    user = User.new(user_params)

    if user.save
      jwt = provide_new_token(user)
      render json: { auth_token: jwt }, status: :created
    else
      render json: { error: user.errors }, status: :bad_request
    end
  end

  # DELETE to destroy user
  def delete
    user = User.find(@current_user.id)

    if user.destroy
      render json: { message: 'Successfully deleted the user' }, status: :ok
    else
      render json: { error: user.errors }, status: :bad_request
    end
  end

  # PUT to update user details
  def update
    user = User.find(@current_user.id)

    # Only allow one at a time
    if user_params[:password].present? && (user_params[:name].present? || user_params[:email].present?)
      render json: { error: "Please only change either the password or the name and email" }, status: :bad_request

    # When updating a password
    # Only notice that this works with a save (due to has_secure_password)
    elsif user_params[:password].present?
      user.password = user_params[:password]

      if user.save
        render json: { ok: true }, status: :ok
      else
        render json: { error: user.errors }, status: :bad_request
      end

    # Now only trying to update what was provided (minus the password)
    elsif user.update_attributes user_params.except(:password)
      render json: { ok: true }, status: :ok
    else
      render json: { error: user.errors }, status: :bad_request
    end
  end

  private

  def provide_new_token(user)
    AuthenticateUser.call(user.email, user.password).result
  end

  def user_params
    params.require(:user).permit(:name, :password, :email)
  end
end
