class CreateMaintenances < ActiveRecord::Migration[5.2]
  def change
    create_table :maintenances do |t|
      t.integer :is_maintenance, limit: 1, null: false

      t.timestamps
    end
  end
end
