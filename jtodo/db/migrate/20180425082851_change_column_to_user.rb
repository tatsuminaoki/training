class ChangeColumnToUser < ActiveRecord::Migration[5.2]
  def up
    change_column :users, :name, :string, null: false
    change_column :users, :password_digest, :string, null: false
    change_column :users, :is_admin, :boolean, default: false
    add_index     :users, [:name], unique: true
  end
  def down
    change_column :users, :name, :string, null: nil
    change_column :users, :password_digest, :string, null: nil
    change_column :users, :is_admin, :boolean, default: nil
    remove_index  :users, [:name]
  end
end
