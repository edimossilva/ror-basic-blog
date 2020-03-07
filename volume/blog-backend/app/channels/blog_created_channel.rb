class BlogCreatedChannel < ApplicationCable::Channel
  def subscribed
    stream_from 'blog_created'
  end

  def unsubscribed; end
end
