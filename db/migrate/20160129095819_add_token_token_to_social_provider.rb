class AddTokenTokenToSocialProvider < ActiveRecord::Migration
  def change
    add_column :social_providers, :token, :string
    add_column :social_providers, :profile_picture, :string
    add_column :social_providers, :profile_url, :string
    add_column :social_providers, :profile_email, :string
  end
end
