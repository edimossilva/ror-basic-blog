class ApplicationController < ActionController::API
  include Auth::JsonWebTokenHelper
  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found # self defined exception

  before_action :authorize_request

  def public_request
    header = request.headers['Authorization']
    return unless header

    header = header.split(' ').last
    @decoded = decode_token(header)
    @current_user = User.find(@decoded[:user_id])
  end

  def render_destroyed
    render status: :no_content
  end

  def render_not_found(exception)
    render json: { error_message: exception.message }, status: :not_found
  end

  def render_ok(entity)
    render json: { data: entity }, status: :ok
  end

  def render_unauthorized
    render status: :unauthorized
  end
end
