class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table "users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
      t.string "name", limit: 45, null: false
      t.integer "authority", limit: 1, null: false
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
    end
  end
end
