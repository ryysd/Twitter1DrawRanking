class CreateTweetValues < ActiveRecord::Migration
  def change
    create_table :tweet_values do |t|
      t.integer :favorite_count, null: false
      t.integer :retweet_count, null: false
      t.integer :reply_count, null: false
      t.integer :tweets_id, null: false

      t.timestamps null: false
    end
  end
end
