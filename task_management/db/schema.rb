# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2018_07_19_011620) do

  create_table "tasks", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.bigint "user_id"
    t.string "task_name", null: false
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.date "due_date"
    t.integer "status", limit: 1, default: 0, null: false, unsigned: true
    t.integer "priority", limit: 1, default: 0, null: false, unsigned: true
    t.index ["user_id"], name: "index_tasks_on_user_id"
  end

  create_table "users", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC", force: :cascade do |t|
    t.string "user_name", null: false
    t.string "mail_address", null: false
    t.string "password_digest", null: false
    t.boolean "admin", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["mail_address"], name: "index_users_on_mail_address", unique: true
  end

  add_foreign_key "tasks", "users"
end
