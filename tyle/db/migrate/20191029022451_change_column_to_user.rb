class ChangeColumnToUser < ActiveRecord::Migration[6.0]
  def change
    change_column :users, :name, :string, null: false
    change_column :users, :login_id, :string, null: false
    change_column :users, :password_digest, :string, null: false
  end
end
