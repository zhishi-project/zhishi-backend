class SetDefaltPointForUsers < ActiveRecord::Migration
  def change
    change_column :users, :points, :integer, default: 10
  end
end
