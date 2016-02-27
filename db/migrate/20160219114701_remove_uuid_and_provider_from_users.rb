class RemoveUuidAndProviderFromUsers < ActiveRecord::Migration
  def change
    remove_column :users, :uuid, :string
    remove_column :users, :provider, :string
  end
end
