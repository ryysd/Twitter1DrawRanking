class AddTumblrIdColumnsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :tumblr_id, :string
  end
end
