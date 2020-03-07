class BlogNotificationService
  def self.on_blog_created(blog)
    ActionCable.server.broadcast 'blog_created', message: blog.name
  end
end
