class CreateLogins < ActiveRecord::Migration[5.1]
  def change
    create_table "logins", id: :bigint, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
      t.bigint "user_id", null: false
      t.string "email", limit: 45, null: false
      t.string "password_digest", null: false
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.index ["email"], name: "email_UNIQUE", unique: true
      t.index ["user_id"], name: "user_id_UNIQUE", unique: true
    end
    add_foreign_key "logins", "users", name: "fk_logins_user", on_update: :cascade, on_delete: :cascade
  end
end
