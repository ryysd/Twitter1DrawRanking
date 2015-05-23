class RemoveCacheColumnsFromRankings < ActiveRecord::Migration
  def change
    remove_column :rankings, :cache
  end
end
