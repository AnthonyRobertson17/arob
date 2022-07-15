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

  test "sets position to 0 if workout has no previous exercises" do
    exercise = create(:exercise)

    assert_equal(0, exercise.position)
  end

  test "increments position based on other exercises for the workout" do
    user = create(:user)
    workout = create(:workout, user:)
    exercises = Array.new(3).map { create(:exercise, workout:) }

    assert_equal((0..2).to_a, exercises.map(&:position))
  end
end
