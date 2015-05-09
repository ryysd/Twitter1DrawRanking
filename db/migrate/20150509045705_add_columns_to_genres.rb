class AddColumnsToGenres < ActiveRecord::Migration
  def change
    add_column :genres, :start_time, :datetime, null: false
  end
end
