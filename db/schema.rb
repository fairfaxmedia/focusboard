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

ActiveRecord::Schema.define(version: 20160826031542) do

  create_table "board_goals", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.integer  "board_id",   limit: 4
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.integer  "priority",   limit: 4
    t.string   "colour",     limit: 255
  end

  add_index "board_goals", ["board_id"], name: "index_board_goals_on_board_id", using: :btree

  create_table "board_memberships", force: :cascade do |t|
    t.integer  "user_id",    limit: 4
    t.integer  "board_id",   limit: 4
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  add_index "board_memberships", ["board_id"], name: "index_board_memberships_on_board_id", using: :btree
  add_index "board_memberships", ["user_id"], name: "index_board_memberships_on_user_id", using: :btree

  create_table "boards", force: :cascade do |t|
    t.string   "name",        limit: 255
    t.integer  "owner_id",    limit: 4
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.string   "jira_url",    limit: 255
    t.text     "standup_url", limit: 65535
  end

  add_index "boards", ["owner_id"], name: "index_boards_on_owner_id", using: :btree

  create_table "completed_tickets", force: :cascade do |t|
    t.integer  "user_id",    limit: 4
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  add_index "completed_tickets", ["user_id"], name: "index_completed_tickets_on_user_id", using: :btree

  create_table "daily_notes", force: :cascade do |t|
    t.text     "content",          limit: 65535
    t.integer  "user_id",          limit: 4
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.boolean  "positive_outcome"
  end

  add_index "daily_notes", ["user_id"], name: "index_daily_notes_on_user_id", using: :btree

  create_table "task_notes", force: :cascade do |t|
    t.text     "content",    limit: 65535
    t.integer  "task_id",    limit: 4
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  add_index "task_notes", ["task_id"], name: "index_task_notes_on_task_id", using: :btree

  create_table "task_statuses", force: :cascade do |t|
    t.string   "status",      limit: 255
    t.integer  "task_id",     limit: 4
    t.datetime "finished_at"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  add_index "task_statuses", ["task_id"], name: "index_task_statuses_on_task_id", using: :btree

  create_table "tasks", force: :cascade do |t|
    t.string   "title",         limit: 255
    t.text     "description",   limit: 65535
    t.string   "status",        limit: 255
    t.integer  "user_id",       limit: 4
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.datetime "completed_at"
    t.integer  "board_id",      limit: 4
    t.string   "jira",          limit: 255
    t.integer  "board_goal_id", limit: 4
  end

  add_index "tasks", ["board_goal_id"], name: "index_tasks_on_board_goal_id", using: :btree
  add_index "tasks", ["board_id"], name: "index_tasks_on_board_id", using: :btree
  add_index "tasks", ["user_id"], name: "index_tasks_on_user_id", using: :btree

  create_table "user_statuses", force: :cascade do |t|
    t.string   "status",     limit: 255
    t.integer  "user_id",    limit: 4
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "user_statuses", ["user_id"], name: "index_user_statuses_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                  limit: 255, default: "",    null: false
    t.string   "encrypted_password",     limit: 255, default: "",    null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          limit: 4,   default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.datetime "created_at",                                         null: false
    t.datetime "updated_at",                                         null: false
    t.boolean  "admin",                              default: false
    t.string   "name",                   limit: 255
    t.boolean  "enabled",                            default: true
    t.string   "confirmation_token",     limit: 255
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email",      limit: 255
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  add_foreign_key "board_goals", "boards"
  add_foreign_key "board_memberships", "boards"
  add_foreign_key "board_memberships", "users"
  add_foreign_key "boards", "users", column: "owner_id"
  add_foreign_key "completed_tickets", "users"
  add_foreign_key "daily_notes", "users"
  add_foreign_key "task_notes", "tasks"
  add_foreign_key "task_statuses", "tasks"
  add_foreign_key "tasks", "users"
  add_foreign_key "user_statuses", "users"
end
