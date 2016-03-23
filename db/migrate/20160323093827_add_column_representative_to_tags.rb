class AddColumnRepresentativeToTags < ActiveRecord::Migration
  def change
    add_column :tags, :representative_id, :integer
  end
end
