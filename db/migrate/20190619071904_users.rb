class Users < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :role, :integer, null: false, default: 1, limit: 1, unsigned: true
  end
end
