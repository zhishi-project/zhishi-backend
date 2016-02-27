class CreateResourceTags < ActiveRecord::Migration
  def change
    create_table :resource_tags do |t|
      t.references :taggable, polymorphic: true, index: true
      t.references :tag, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
