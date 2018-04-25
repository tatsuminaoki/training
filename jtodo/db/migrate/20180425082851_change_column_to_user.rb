class ChangeColumnToUser < ActiveRecord::Migration[5.2]
  def change
    change_column :users, :name, :string, unique: true, null: false
    change_column :users, :password_digest, :string, null: false
    change_column_default :users, :is_admin, 0
  end
end
