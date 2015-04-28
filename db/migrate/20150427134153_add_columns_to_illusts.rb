class AddColumnsToIllusts < ActiveRecord::Migration
  def change
    add_column :illusts, :authors_id, :integer, :null => false
    add_column :illusts, :genres_id, :integer, :null => false
    add_column :illusts, :url, :string, :null => false
    add_column :illusts, :favorited_count, :integer, :null => false
    add_column :illusts, :retweeted_count, :integer, :null => false
    add_column :illusts, :reply_count, :integer, :null => false
  end
end
