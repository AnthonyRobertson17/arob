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

ActiveRecord::Schema[7.0].define(version: 2024_04_28_224620) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "equipment", force: :cascade do |t|
    t.string "name", null: false
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_equipment_on_user_id"
  end

  create_table "equipment_exercise_types", id: false, force: :cascade do |t|
    t.bigint "equipment_id", null: false
    t.bigint "exercise_type_id", null: false
  end

  create_table "equipment_gyms", id: false, force: :cascade do |t|
    t.bigint "equipment_id", null: false
    t.bigint "gym_id", null: false
  end

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
    t.integer "position", null: false
    t.index ["exercise_type_id"], name: "index_exercises_on_exercise_type_id"
    t.index ["workout_id"], name: "index_exercises_on_workout_id"
  end

  create_table "food_groups", force: :cascade do |t|
    t.string "name", null: false
    t.string "emoji", limit: 1, null: false
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id", "name"], name: "index_food_groups_on_user_id_and_name", unique: true
    t.index ["user_id"], name: "index_food_groups_on_user_id"
  end

  create_table "food_groups_foods", id: false, force: :cascade do |t|
    t.bigint "food_group_id", null: false
    t.bigint "food_id", null: false
  end

  create_table "foods", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.index ["user_id", "name"], name: "index_foods_on_user_id_and_name", unique: true
    t.index ["user_id"], name: "index_foods_on_user_id"
  end

  create_table "gyms", force: :cascade do |t|
    t.string "name", null: false
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_gyms_on_user_id"
  end

  create_table "links", force: :cascade do |t|
    t.string "url", null: false
    t.string "linkable_type"
    t.bigint "linkable_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["linkable_type", "linkable_id"], name: "index_links_on_linkable"
  end

  create_table "meals", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "date"
    t.integer "meal_type", default: 0, null: false
    t.string "name"
    t.bigint "user_id"
    t.index ["user_id"], name: "index_meals_on_user_id"
  end

  create_table "portions", force: :cascade do |t|
    t.decimal "serving_quantity", null: false
    t.bigint "user_id"
    t.bigint "food_group_id"
    t.bigint "meal_id"
    t.bigint "food_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["food_group_id"], name: "index_portions_on_food_group_id"
    t.index ["food_id"], name: "index_portions_on_food_id"
    t.index ["meal_id"], name: "index_portions_on_meal_id"
    t.index ["user_id"], name: "index_portions_on_user_id"
  end

  create_table "practice_putts", force: :cascade do |t|
    t.boolean "sunk", default: false, null: false
    t.integer "distance", default: 0, null: false
    t.integer "direction", default: 0, null: false
    t.bigint "putting_practice_session_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["putting_practice_session_id"], name: "index_practice_putts_on_putting_practice_session_id"
  end

  create_table "putting_practice_sessions", force: :cascade do |t|
    t.decimal "hole_distance", default: "3.0", null: false
    t.integer "hole_size", default: 0, null: false
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_putting_practice_sessions_on_user_id"
  end

  create_table "serving_definitions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "serving_quantity"
    t.bigint "user_id"
    t.bigint "food_id"
    t.bigint "food_group_id"
    t.bigint "serving_unit_id"
    t.index ["food_group_id"], name: "index_serving_definitions_on_food_group_id"
    t.index ["food_id"], name: "index_serving_definitions_on_food_id"
    t.index ["serving_unit_id"], name: "index_serving_definitions_on_serving_unit_id"
    t.index ["user_id"], name: "index_serving_definitions_on_user_id"
  end

  create_table "serving_units", force: :cascade do |t|
    t.string "name", null: false
    t.string "abbreviation"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id", "name"], name: "index_serving_units_on_user_id_and_name", unique: true
    t.index ["user_id"], name: "index_serving_units_on_user_id"
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

  create_table "wishlist_items", force: :cascade do |t|
    t.string "name", null: false
    t.bigint "wishlist_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "price", precision: 8, scale: 2
    t.text "description"
    t.index ["wishlist_id"], name: "index_wishlist_items_on_wishlist_id"
  end

  create_table "wishlists", force: :cascade do |t|
    t.string "name", null: false
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_wishlists_on_user_id"
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
