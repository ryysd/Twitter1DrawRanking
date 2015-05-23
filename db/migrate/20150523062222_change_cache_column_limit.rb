class ChangeCacheColumnLimit < ActiveRecord::Migration
  def change
    change_column :rankings, :cache, :binary, limit: 1.megabytes
  end
end
