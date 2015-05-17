class AddColumnToGenres < ActiveRecord::Migration
  def change
    add_column :genres, :alias, :string
  end
end
