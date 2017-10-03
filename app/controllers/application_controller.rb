class ApplicationController < ActionController::API
  before_action :authenticate_request
  attr_reader :current_user

  def authenticate_request
    @current_user = AuthorizeApiRequests.call(request.headers).result
    render json: { error: 'Not Authorized' }, status: 401 unless @current_user
  end
end
