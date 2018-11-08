class EditColumnUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :password_digest, :string

    remove_column :users, :encrypted_password, :string
  end
end
