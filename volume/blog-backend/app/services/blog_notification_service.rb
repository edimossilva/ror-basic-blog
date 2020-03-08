class BlogNotificationService
  def self.on_blog_created(blog)
    blog_message = "Blog(id:#{blog.id}, name:#{blog.name})"
    user_message = blog.user.fields_string
    full_message = "#{blog_message} created by #{user_message}"

    ActionCable.server.broadcast 'blog_created', message: full_message
  end
end
