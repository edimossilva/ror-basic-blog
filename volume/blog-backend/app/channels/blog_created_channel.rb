class BlogCreatedChannel < ApplicationCable::Channel
  include Auth::JsonWebTokenHelper

  def subscribed
    user = user_by_token(params[:token])
    stream_from 'blog_created' if user&.admin?
  end

  def unsubscribed; end
end
