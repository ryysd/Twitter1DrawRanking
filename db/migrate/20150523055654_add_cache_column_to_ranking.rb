class AddCacheColumnToRanking < ActiveRecord::Migration
  def change
    add_column :rankings, :cache, :string
  end
end
