# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 0) do

  create_table "logins", force: :cascade do |t|
    t.integer  "user_id",         limit: 8,   null: false
    t.string   "email",           limit: 45,  null: false
    t.string   "password_digest", limit: 255, null: false
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  add_index "logins", ["email"], name: "email_UNIQUE", unique: true, using: :btree
  add_index "logins", ["user_id"], name: "user_id_UNIQUE", unique: true, using: :btree

  create_table "maintenances", force: :cascade do |t|
    t.datetime "start_at",   null: false
    t.datetime "end_at",     null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

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

  create_table "users", force: :cascade do |t|
    t.string   "name",       limit: 45, null: false
    t.integer  "authority",  limit: 1,  null: false
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
  end

  add_foreign_key "logins", "users", name: "fk_user"
  add_foreign_key "tasks", "users", name: "fk_task_user1"
end
