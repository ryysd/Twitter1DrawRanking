class ChangeDatatypeIdOfTweetValues < ActiveRecord::Migration
  def change
    change_column :tweet_values, :tweets_id, :integer, limit: 8
  end
end
