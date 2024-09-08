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
    create_list(:exercise_set, 3, exercise:)

    assert_equal 3, exercise.exercise_sets.count
  end

  test "name is delegated to exercise_type" do
    exercise_type = create(:exercise_type, name: "lolol")
    exercise = create(:exercise, exercise_type:)

    assert_equal("lolol", exercise.name)
  end
end
