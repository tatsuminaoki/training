class ChangeEmailToAccount < ActiveRecord::Migration[5.2]
  def up
    remove_column :users, :email
    add_column :users, :account, :string, null: false
    add_index :users, :account, unique: true
  end
  def down
    add_column :users, :email, :string, null: false
    add_index :users, :email, unique: true
    remove_column :users, :account
  end
end
