class AddAccessLevelToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :access_level, :integer
  end
end
