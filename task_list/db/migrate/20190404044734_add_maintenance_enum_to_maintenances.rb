class AddMaintenanceEnumToMaintenances < ActiveRecord::Migration[5.2]
  def change
    add_column :maintenances, :maintenance_enum, :integer
  end
end
