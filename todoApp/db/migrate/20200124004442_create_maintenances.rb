class CreateMaintenances < ActiveRecord::Migration[6.0]
  def change
    create_table :maintenances do |t|
      t.boolean :maintenance_mode, default: false

      t.timestamps
    end
  end
end
