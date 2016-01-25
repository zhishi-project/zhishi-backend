class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.integer :user_id
      t.string :content
      t.integer :votes
      t.references :comment_on, polymorphic: true, index: true

      t.timestamps null: false
    end
  end
end
