class AddColumnToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :role, :unsigned_tinyint, null: false, after: :password_digest
  end
end
