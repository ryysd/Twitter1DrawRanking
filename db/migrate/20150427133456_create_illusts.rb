class CreateIllusts < ActiveRecord::Migration
  def change
    create_table :illusts do |t|

      t.timestamps null: false
    end
  end
end
