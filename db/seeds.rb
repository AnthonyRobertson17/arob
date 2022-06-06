# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

user_1 = User.create!(
  email: "dev@test.test",
  password: "password12345",
)

user_2 = User.create!(
  email: "dev2@test.test",
  password: "password12345",
)

legs_category = WorkoutCategory.create!(name: "Legs")
chest_category = WorkoutCategory.create!(name: "Chest")

Workout.create!([
  {
    name: "Leg Day",
    workout_category: legs_category,
    user: user_1,
  },
  {
    name: "Chest Day",
    workout_category: chest_category,
    started_at: 2.days.ago,
    completed_at: 2.days.ago + 1.hour,
    user: user_1,
  },
  {
    name: "Silly Day",
    workout_category: chest_category,
    started_at: 2.days.ago,
    completed_at: 2.days.ago + 1.hour,
    user: user_2,
  },
])
