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

ActiveRecord::Schema.define(version: 2019_04_15_081605) do

  create_table "statuses", id: :integer, limit: 1, default: nil, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "status_name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["status_name"], name: "index_statuses_on_status_name", unique: true
  end

  create_table "tasks", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "task_name", null: false
    t.string "contents", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "status_id", limit: 1, default: 1, null: false
    t.bigint "user_id", null: false
    t.index ["status_id"], name: "fk_rails_dce14077b1"
    t.index ["task_name"], name: "index_tasks_on_task_name", unique: true
    t.index ["user_id"], name: "fk_rails_4d2a9e4d7e"
  end

  create_table "users", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "user_name", null: false
    t.string "password", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "tasks", "statuses"
  add_foreign_key "tasks", "users"
end
