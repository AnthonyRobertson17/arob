# frozen_string_literal: true

require "test_helper"

class ExerciseTest < ActiveSupport::TestCase
  test "can access workout through association" do
    workout = create(:workout, name: "hehehe")
    exercise = create(:exercise, workout:)

    assert_equal "hehehe", exercise.workout.name
  end

  test "can access exercise type through association" do
    exercise_type = create(:exercise_type, name: "lolol")
    exercise = create(:exercise, exercise_type:)

    assert_equal "lolol", exercise.exercise_type.name
  end

  test "can access exercise_sets through association" do
    exercise = create(:exercise)
    3.times { create(:exercise_set, exercise:) }

    assert_equal 3, exercise.exercise_sets.count
  end

  test "validates uniqueness of position within scope of the workout" do
    user = create(:user)
    workout = create(:workout, user:)
    create(:exercise, workout:)
    bad_exercise = create(:exercise, workout:)

    bad_exercise.position = 0
    assert_not(bad_exercise.valid?)
  end

  test "exercises can share position if they don't share a workout" do
    exercise1 = create(:exercise)
    exercise2 = create(:exercise)

    assert_equal(exercise1.position, exercise2.position)
    assert_predicate(exercise2, :valid?)
  end

  test "validates that position must be >= 0" do
    exercise = create(:exercise)
    exercise.position = -1
    assert_not(exercise.valid?)
  end

  test "sets position to 0 if workout has no previous exercises" do
    exercise = create(:exercise)

    assert_equal(0, exercise.position)
  end

  test "increments position based on other exercises for the workout" do
    workout = create(:workout)
    exercises = Array.new(3).map { create(:exercise, workout:) }

    assert_equal((0..2).to_a, exercises.map(&:position))
  end

  test "general update to exercise doesn't change position" do
    user = create(:user)
    exercise_type = create(:exercise_type, user:, name: "lolol")
    workout = create(:workout, user:)
    exercises = Array.new(3).map { create(:exercise, workout:) }

    exercises.first.update!(exercise_type:)

    assert_equal((0..2).to_a, exercises.map(&:position))
  end

  test "destroying the exercise updates the positions of the other exercises in the workout" do
    workout = create(:workout)
    exercises = Array.new(8).map { create(:exercise, workout:) }

    exercises[2].destroy!

    assert_equal((0..6).to_a, workout.reload.exercises.map(&:position))
  end
end
