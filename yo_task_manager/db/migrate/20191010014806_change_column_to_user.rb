class ChangeColumnToUser < ActiveRecord::Migration[6.0]
  def up
    rename_column :users, :password, :password_digest
    change_column :users, :password_digest, :string, null: false
    change_column :users, :login_id, :string, null: false
  end

  def down
    change_column :users, :login_id, :string, null: true
    change_column :users, :password_digest, :string, null: true
    rename_column :users, :password_digest, :password
  end
end
