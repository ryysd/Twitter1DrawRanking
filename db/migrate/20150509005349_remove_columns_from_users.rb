class RemoveColumnsFromUsers < ActiveRecord::Migration
  def change
    remove_column :users, :twitter_id, :string
  end
end
