class ChangeCacheColumnDataTypeOfRankingTable < ActiveRecord::Migration
  def change
    change_column :rankings, :cache, :binary
  end
end
