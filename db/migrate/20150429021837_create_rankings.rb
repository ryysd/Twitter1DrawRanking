class CreateRankings < ActiveRecord::Migration
  def change
    create_table :rankings do |t|
      t.integer :genres_id
      t.integer :ranking_types_id

      t.timestamps null: false
    end
  end
end
