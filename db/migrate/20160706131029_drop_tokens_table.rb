class DropTokensTable < ActiveRecord::Migration
  def up
    remove_index :tokens, :temp
    remove_index :tokens, :user_id
    drop_table :tokens
  end

  def down
    create_table "tokens", force: :cascade do |t|
      t.integer  "user_id"
      t.string   "temp"
      t.integer  "status",     default: 0
      t.datetime "created_at",             null: false
      t.datetime "updated_at",             null: false
    end

    add_index "tokens", ["temp"], name: "index_tokens_on_temp"
    add_index "tokens", ["user_id"], name: "index_tokens_on_user_id"
  end
end
