# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2022_07_14_030556) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "exercise_sets", force: :cascade do |t|
    t.bigint "exercise_id"
    t.integer "repetitions"
    t.decimal "weight"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["exercise_id"], name: "index_exercise_sets_on_exercise_id"
  end

  create_table "exercise_type_tag_assignments", force: :cascade do |t|
    t.bigint "tag_id", null: false
    t.bigint "exercise_type_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["exercise_type_id"], name: "index_exercise_type_tag_assignments_on_exercise_type_id"
    t.index ["tag_id"], name: "index_exercise_type_tag_assignments_on_tag_id"
  end

  create_table "exercise_types", force: :cascade do |t|
    t.string "name", null: false
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_exercise_types_on_name"
    t.index ["user_id", "name"], name: "index_exercise_types_on_user_id_and_name", unique: true
    t.index ["user_id"], name: "index_exercise_types_on_user_id"
  end

  create_table "exercises", force: :cascade do |t|
    t.bigint "workout_id"
    t.bigint "exercise_type_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "note"
    t.integer "position", default: 0, null: false
    t.index ["exercise_type_id"], name: "index_exercises_on_exercise_type_id"
    t.index ["workout_id"], name: "index_exercises_on_workout_id"
  end

  create_table "sets", force: :cascade do |t|
    t.bigint "exercise_id"
    t.integer "repetitions"
    t.decimal "weight"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["exercise_id"], name: "index_sets_on_exercise_id"
  end

  create_table "tags", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.string "type"
    t.index ["name", "user_id"], name: "index_tags_on_name_and_user_id"
    t.index ["name"], name: "index_tags_on_name"
    t.index ["user_id", "name", "type"], name: "index_tags_on_user_id_and_name_and_type", unique: true
    t.index ["user_id"], name: "index_tags_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "time_zone", default: "UTC"
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  create_table "workout_tag_assignments", force: :cascade do |t|
    t.bigint "tag_id", null: false
    t.bigint "workout_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["tag_id"], name: "index_workout_tag_assignments_on_tag_id"
    t.index ["workout_id"], name: "index_workout_tag_assignments_on_workout_id"
  end

  create_table "workouts", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "started_at"
    t.datetime "completed_at"
    t.bigint "user_id"
    t.index ["name"], name: "index_workouts_on_name"
    t.index ["user_id"], name: "index_workouts_on_user_id"
  end

  add_foreign_key "exercise_type_tag_assignments", "exercise_types"
  add_foreign_key "exercise_type_tag_assignments", "tags"
  add_foreign_key "tags", "users"
  add_foreign_key "workout_tag_assignments", "tags"
  add_foreign_key "workout_tag_assignments", "workouts"
  add_foreign_key "workouts", "users"
end
