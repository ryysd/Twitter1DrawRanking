class RemoveColmunsFromTweets < ActiveRecord::Migration
  def change
    remove_column :tweets, :favorite_count, :integer
    remove_column :tweets, :retweet_count, :integer
    remove_column :tweets, :reply_count, :integer
  end
end
