class AddColumnToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :remember_token, :string
    add_column :users, :role, :integer
  end
end
