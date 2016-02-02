class CreateVotes < ActiveRecord::Migration
  def change
    create_table :votes do |t|
      t.integer :user_id, index: true
      t.integer :value
      t.references :voteable, polymorphic: true, index: true

      t.timestamps null: false
    end
  end
end
