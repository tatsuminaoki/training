class ChangeColumnsForUser < ActiveRecord::Migration[5.2]
  def up
    change_column :users, :login_id, :string, null: false
    change_column :users, :password_hash, :string, null: false
    change_column :users, :admin_flag, :boolean, null: false, default: false
  end

  def down
    change_column :users, :login_id, :string, null: true
    change_column :users, :password_hash, :string, null: true
    change_column :users, :admin_flag, :boolean, null: true, default: nil
  end
end
