class RemoveStartFromMaintenances < ActiveRecord::Migration[5.2]
  def change
    remove_column :maintenances, :start, :boolean
    remove_column :maintenances, :finish, :boolean
  end
end
