class CahngeDatatypeIdOfTweets < ActiveRecord::Migration
  def change
    change_column :illusts, :id, :integer, limit: 8
  end
end
