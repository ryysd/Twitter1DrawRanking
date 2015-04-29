class CreateRankingTypes < ActiveRecord::Migration
  def change
    create_table :ranking_types do |t|
      t.string :name

      t.timestamps null: false
    end
  end
end
