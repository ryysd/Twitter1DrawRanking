class RemoveColumnsFromIllusts < ActiveRecord::Migration
  def change
    remove_column :illusts, :favorited_count, :integer
    remove_column :illusts, :retweeted_count, :integer
    remove_column :illusts, :reply_count, :integer
    remove_column :illusts, :authors_id, :integer
    remove_column :illusts, :genres_id, :integer
  end
end
