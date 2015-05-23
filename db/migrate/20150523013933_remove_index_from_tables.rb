class RemoveIndexFromTables < ActiveRecord::Migration
  def change
    remove_index :users, :id
    remove_index :tweet_values, [:id, :tweet_id]
    remove_index :illusts, [:id, :tweet_id]
    remove_index :tweet_rankings, :id
  end
end
