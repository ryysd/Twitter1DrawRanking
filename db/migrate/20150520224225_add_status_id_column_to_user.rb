class AddStatusIdColumnToUser < ActiveRecord::Migration
  def change
    remove_column :users, :checked_date
    add_column :users, :status_id, :integer
  end
end
