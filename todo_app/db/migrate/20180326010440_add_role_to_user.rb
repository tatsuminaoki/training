class AddRoleToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :role, :tinyint, after: :name
  end
end
