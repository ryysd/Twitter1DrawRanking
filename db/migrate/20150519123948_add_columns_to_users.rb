class AddColumnsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :followers_count, :integer
    add_column :users, :follow_count, :integer
    add_column :users, :pixiv_id, :int, limit: 8
    add_column :users, :description, :string
    add_column :users, :checked_date, :date
  end
end
