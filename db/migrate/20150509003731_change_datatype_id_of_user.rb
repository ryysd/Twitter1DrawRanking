class ChangeDatatypeIdOfUser < ActiveRecord::Migration
  def change
    change_column :users, :id, :integer, limit: 8
  end
end
