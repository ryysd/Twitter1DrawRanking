class AddTextToTweets < ActiveRecord::Migration
  def change
    add_column :tweets, :text, :string, null: false
  end
end
