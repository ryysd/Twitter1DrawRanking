class AddIndexToTables < ActiveRecord::Migration
  def change
    add_index :users, :id
    add_index :tweet_values, [:id, :tweet_id]
    add_index :illusts, [:id, :tweet_id]
    add_index :tweet_rankings, :id
  end
end
