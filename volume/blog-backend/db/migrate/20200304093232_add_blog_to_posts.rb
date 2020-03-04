class AddBlogToPosts < ActiveRecord::Migration[6.0]
  def change
    add_reference :posts, :blog, null: false, foreign_key: true
  end
end
