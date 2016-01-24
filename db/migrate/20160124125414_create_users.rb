class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :uuid
      t.string :provider
      t.integer :points

      t.timestamps null: false
    end
  end
end
