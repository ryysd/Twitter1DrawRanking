class AddReliabilityColumnToUser < ActiveRecord::Migration
  def change
    add_column :users, :reliability, :integer
  end
end
