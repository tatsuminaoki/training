class ChangeColumnToUser < ActiveRecord::Migration[5.2]
  def up
    change_column :users, :name, :string, unique: true, null: false
    change_column :users, :password_digest, :string, null: false
    change_column :users, :is_admin, :boolean, default: false
  end
end
