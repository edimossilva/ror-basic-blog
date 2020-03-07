# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

user1 = User.create(username: 'registered_user1', password: '111', access_level: User.access_levels[:registred])
user2 = User.create(username: 'registered_user2', password: '222', access_level: User.access_levels[:registred])
User.create(username: 'admin_user1', password: '111', access_level: User.access_levels[:admin])
User.create(username: 'admin_user2', password: '222', access_level: User.access_levels[:admin])

blog1 = Blog.create(name: 'registered_user1 news', user_id: user1.id, is_private: false)
blog2 = Blog.create(name: 'registered_user2 olds', user_id: user2.id, is_private: true)

Post.create(title: 'post title1', blog_id: blog1.id, user_id: user1.id)
Post.create(title: 'post title2', blog_id: blog2.id, user_id: user2.id)
