class ChangeDatatypeTweetsidOfIllusts < ActiveRecord::Migration
  def change
    change_column :illusts, :tweets_id, :integer, limit: 8
  end
end
