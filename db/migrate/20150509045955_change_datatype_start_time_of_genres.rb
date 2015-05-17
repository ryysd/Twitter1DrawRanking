class ChangeDatatypeStartTimeOfGenres < ActiveRecord::Migration
  def change
    change_column :genres, :start_time, :time
  end
end
