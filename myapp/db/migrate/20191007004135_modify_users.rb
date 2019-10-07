class ModifyUsers < ActiveRecord::Migration[6.0]
  def change
    rename_column :users, :password_digest, :encrypted_password
    remove_column :users, :remember_token, :string
    add_column :users, :remember_created_at, :datetime, after: :encrypted_password
  end
end
