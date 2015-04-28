class CreateTweets < ActiveRecord::Migration
  def change
    create_table :tweets do |t|
      t.string :url, null: false
      t.integer :favorite_count, null: false
      t.integer :retweet_count, null: false
      t.integer :reply_count, null: false
      t.integer :authors_id, null: false
      t.integer :genres_id, null: false

      t.timestamps null: false
    end
  end
end
