# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

user1 = User.create!(
  email: "dev@test.test",
  password: "password12345",
)

user2 = User.create!(
  email: "dev2@test.test",
  password: "password12345",
)

legs_category = WorkoutCategory.create!(name: "Legs", user: user1)
chest_category = WorkoutCategory.create!(name: "Chest", user: user1)

user2_category = WorkoutCategory.create!(name: "Chest for user 2", user: user2)

Workout.create!([
  {
    name: "Leg Day",
    workout_category: legs_category,
    user: user1,
  },
  {
    name: "Chest Day",
    workout_category: chest_category,
    started_at: 2.days.ago,
    completed_at: 2.days.ago + 1.hour,
    user: user1,
  },
  {
    name: "Silly Day",
    workout_category: user2_category,
    started_at: 2.days.ago,
    completed_at: 2.days.ago + 1.hour,
    user: user2,
  },
])
