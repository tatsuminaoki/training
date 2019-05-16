class ChangeNameAndPasswordColumnToUser < ActiveRecord::Migration[5.2]
  def change
    change_column_null :users, :name, false
    change_column_null :users, :password_digest, false
    add_index :users, :name, unique: true
  end
end
