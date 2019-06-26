class AddColumnsToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :mail, :string, before: :created_at
    add_column :users, :password_digest, :string, before: :created_at
    add_column :users, :remember_token, :string, before: :created_at
  end
end
