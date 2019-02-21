class AddRoleToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :role, :integer, after: :password_digest, limit: 1, null: false, default: 0
  end
end
