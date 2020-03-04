class ApplicationController < ActionController::API
  before_action :authorize_request
  def authorize_request
    header = request.headers['Authorization']
    header = header.split(' ').last if header
    begin
      @decoded = JsonWebToken.decode(header)
      @current_user = User.find(@decoded[:user_id])
    rescue ActiveRecord::RecordNotFound => e
      render json: { errors: e.message }, status: :unauthorized
    rescue JWT::DecodeError => e
      render json: { errors: e.message }, status: :unauthorized
    end
  end

  def public_request
    header = request.headers['Authorization']
    if header
      header = header.split(' ').last
      @decoded = JsonWebToken.decode(header)
      @current_user = User.find(@decoded[:user_id])
    end
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

  def destroy_params
    params.permit(:id)[:id]
  end

  def show_params
    params.permit(:id)[:id]
  end
end
