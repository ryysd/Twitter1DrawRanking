class CreateTweetRankings < ActiveRecord::Migration
  def change
    create_table :tweet_rankings do |t|
      t.integer :ranking_id, null: false
      t.integer :tweet_id, limit: 8, null: false

      t.timestamps null: false
    end
  end
end
