class AddIndexToColumns < ActiveRecord::Migration
  def change
    add_index :tweet_values, :tweet_id
    add_index :illusts, :tweet_id
    add_index :tweet_rankings, :tweet_id
  end
end
