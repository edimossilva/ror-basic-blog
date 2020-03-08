class PostDeletedChannel < ApplicationCable::Channel
  include Auth::JsonWebTokenHelper

  def subscribed
    user = user_by_token(params[:token])
    stream_from "post_deleted_user_#{user.id}" if user&.registred?
  end

  def unsubscribed; end
end
