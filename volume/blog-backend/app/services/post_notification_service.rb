class PostNotificationService
  def self.on_post_deleted(post)
    post_message = "Post(id:#{post.id}, title:#{post.title})"
    full_message = "#{post_message} deleted"

    ActionCable.server.broadcast "post_deleted_user_#{post.user.id}", message: full_message
  end
end
