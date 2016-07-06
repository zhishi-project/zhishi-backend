class DropSocialProviderTable < ActiveRecord::Migration
  def up
    remove_index :social_providers, :user_id
    drop_table :social_providers
  end

  def down
    create_table :social_providers do |t|
      t.string :provider
      t.string :uuid
      t.string :auth_token
      t.string :refresh_token
      t.references :user, index: true, foreign_key: true
      t.string :token
      t.string :profile_picture
      t.string :profile_url
      t.string :email

      t.timestamps null: false
    end
  end
end
