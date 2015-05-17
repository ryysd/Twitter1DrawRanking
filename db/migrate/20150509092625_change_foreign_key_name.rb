class ChangeForeignKeyName < ActiveRecord::Migration
  def change
    rename_column :tweets, :users_id, :user_id
    rename_column :tweets, :genres_id, :genre_id
    rename_column :tweet_values, :tweets_id, :tweet_id
    rename_column :rankings, :genres_id, :genre_id
    rename_column :rankings, :ranking_types_id, :ranking_type_id
    rename_column :illusts, :tweets_id, :tweet_id
  end
end
