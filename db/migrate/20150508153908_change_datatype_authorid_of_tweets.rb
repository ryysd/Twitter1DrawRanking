class ChangeDatatypeAuthoridOfTweets < ActiveRecord::Migration
  def change
    change_column :tweets, :authors_id, :integer, limit: 8
  end
end
