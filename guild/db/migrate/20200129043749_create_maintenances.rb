class CreateMaintenances < ActiveRecord::Migration[5.1]
  def change
    create_table "maintenances", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
      t.datetime "start_at", null: false
      t.datetime "end_at", null: false
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
    end
  end
end
