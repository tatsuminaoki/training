class RenamePasswordToUser < ActiveRecord::Migration[5.2]
  def up
    rename_column :users, :encrypted_password, :password_digest
  end

  def def
    rename_column :users, :password_digest, :encrypted_password
  end
end
