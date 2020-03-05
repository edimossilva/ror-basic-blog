class ApplicationController < ActionController::API
  include Auth::JsonWebTokenHelper

  before_action :authorize_request
  def authorize_request
    header = request.headers['Authorization']
    header = header.split(' ').last if header
    begin
      @decoded = decode_token(header)
      @current_user = User.find(@decoded[:user_id])
    rescue ActiveRecord::RecordNotFound => e
      render json: { errors: e.message }, status: :unauthorized
    rescue JWT::DecodeError => e
      render json: { errors: e.message }, status: :unauthorized
    end
  end

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

  def render_not_found(klass, id)
    error_message = "#{klass.name} not found with id:#{id}"
    render json: { error_message: error_message }, status: :not_found
  end

  def render_ok(entity)
    render json: { data: entity }, status: :ok
  end

  def render_unauthorized
    render status: :unauthorized
  end
end
