class RenameProfileEmailToEmail < ActiveRecord::Migration
  def change
    rename_column :social_providers, :profile_email, :email
  end
end
