class AddColumnAdminToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :admin, :boolean, after: :remember_created_at
  end
end
