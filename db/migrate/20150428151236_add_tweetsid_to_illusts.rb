class AddTweetsidToIllusts < ActiveRecord::Migration
  def change
    add_column :illusts, :tweets_id, :integer, null: false
  end
end
