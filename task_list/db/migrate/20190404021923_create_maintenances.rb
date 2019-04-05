class CreateMaintenances < ActiveRecord::Migration[5.2]
  def change
    create_table :maintenances do |t|
      t.boolean :start, default: false
      t.boolean :finish, default: true

      t.timestamps
    end
  end
end
