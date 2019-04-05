class AddIndexToLabelsName < ActiveRecord::Migration[5.2]
  def change
    change_column :maintenances, :maintenance_enum, :integer, null: false
  end
end
