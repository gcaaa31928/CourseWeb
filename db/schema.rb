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

ActiveRecord::Schema.define(version: 20160309172500) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "admins", force: :cascade do |t|
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.string   "access_token"
  end

  create_table "charts", force: :cascade do |t|
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.integer  "course_id"
    t.text     "average_commits_count"
    t.text     "high_standard_commits_count"
    t.text     "low_standard_commits_count"
    t.text     "average_loc"
    t.text     "high_standard_loc"
    t.text     "low_standard_loc"
  end

  create_table "courses", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.integer  "academic_year"
  end

  create_table "deliver_homeworks", force: :cascade do |t|
    t.integer  "student_id"
    t.integer  "homework_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "forgot_password_tokens", force: :cascade do |t|
    t.integer  "student_id"
    t.string   "token"
    t.datetime "expire_at"
  end

  create_table "groups", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "course_id"
  end

  create_table "homeworks", force: :cascade do |t|
    t.string   "name"
    t.integer  "course_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "notifications", force: :cascade do |t|
    t.text     "text"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "privileges", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "projects", force: :cascade do |t|
    t.string   "name"
    t.string   "description"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.string   "project_type"
    t.string   "ref_url"
    t.integer  "group_id"
  end

  create_table "roll_calls", force: :cascade do |t|
    t.integer  "period"
    t.date     "date"
    t.integer  "student_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "scores", force: :cascade do |t|
    t.integer  "teaching_assistant_id"
    t.integer  "point"
    t.integer  "no"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
    t.integer  "project_id"
  end

  create_table "students", force: :cascade do |t|
    t.string   "name"
    t.string   "class_name"
    t.integer  "course_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.string   "access_token"
    t.string   "password_hash"
    t.string   "email"
    t.integer  "group_id"
  end

  create_table "teaching_assistants", force: :cascade do |t|
    t.string   "name"
    t.integer  "course_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.string   "access_token"
    t.string   "class_name"
    t.string   "email"
    t.string   "password_hash"
  end

  create_table "teaching_assistants_privileges", id: false, force: :cascade do |t|
    t.integer "teaching_assistant_id"
    t.integer "privilege_id"
  end

  create_table "time_costs", force: :cascade do |t|
    t.integer  "student_id", null: false
    t.integer  "cost"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "timelog_id", null: false
    t.integer  "category"
  end

  add_index "time_costs", ["id"], name: "index_time_costs_on_id", unique: true, using: :btree

  create_table "timelogs", force: :cascade do |t|
    t.integer  "week_no"
    t.date     "date"
    t.integer  "personal_time_cost"
    t.string   "todo"
    t.integer  "category"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.integer  "project_id"
    t.integer  "main_force"
    t.text     "image"
  end

end
