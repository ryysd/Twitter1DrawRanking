class RenameAuthorsidColumnToUsersidOfTweets < ActiveRecord::Migration
  def change
    rename_column :tweets, :authors_id, :users_id
  end
end
