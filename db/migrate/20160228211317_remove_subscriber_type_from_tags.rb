class RemoveSubscriberTypeFromTags < ActiveRecord::Migration
  def change
    remove_column :tags, :subscriber_type, :string
    remove_column :tags, :subscriber_id, :integer
  end
end
