class CreateSocialProviders < ActiveRecord::Migration
  def change
    create_table :social_providers do |t|
      t.string :provider
      t.string :uuid
      t.string :auth_token
      t.string :refresh_token
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
