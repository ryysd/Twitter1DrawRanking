class CreateUserStatusTable < ActiveRecord::Migration
  def change
    create_table :user_statuses do |t|
      t.string :value
    end
  end
end
