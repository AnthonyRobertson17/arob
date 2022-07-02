# frozen_string_literal: true

require "test_helper"

class ExerciseTest < ActiveSupport::TestCase
  test "can access workout through association" do
    workout = build :workout, name: "hehehe"
    exercise = build :exercise, workout: workout

    assert_equal "hehehe", exercise.workout.name
  end

  test "can access exercise type through association" do
    exercise_type = build :exercise_type, name: "lolol"
    exercise = build :exercise, exercise_type: exercise_type

    assert_equal "lolol", exercise.exercise_type.name
  end
end
