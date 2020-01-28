class CreateTasks < ActiveRecord::Migration[5.1]
  def change
    create_table "tasks", force: :cascade do |t|
      t.integer  "user_id",     limit: 8,     null: false
      t.text     "subject",     limit: 65535, null: false
      t.text     "description", limit: 65535, null: false
      t.integer  "state",       limit: 1,     null: false
      t.integer  "priority",    limit: 1,     null: false
      t.integer  "label",       limit: 1,     null: false
      t.datetime "created_at",                null: false
      t.datetime "updated_at",                null: false
    end

    add_index "tasks", ["user_id"], name: "fk_task_user1", using: :btree
  end
end
