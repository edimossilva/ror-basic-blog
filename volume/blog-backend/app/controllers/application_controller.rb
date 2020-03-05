class ApplicationController < ActionController::API
  include Auth::JsonWebTokenHelper
  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found
  rescue_from ActiveRecord::RecordInvalid, with: :render_unprocessable_entity

  before_action :authorize_request

  def render_created(entity)
    render json: { data: entity }, status: :created
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

  def render_unprocessable_entity(exception)
    render json: { error_message: exception.message }, status: :unprocessable_entity
  end
end
