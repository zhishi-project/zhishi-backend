class CreateTokens < ActiveRecord::Migration
  def change
    create_table :tokens do |t|
      t.references :user, index: true
      t.string :temp, index: true
      t.integer :status, default: 0

      t.timestamps null: false
    end
  end
end
