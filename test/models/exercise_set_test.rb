# frozen_string_literal: true

require "test_helper"

class ExerciseSetTest < ActiveSupport::TestCase
  test "can access exercise through association" do
    exercise = create(:exercise)
    exercise_set = create(:exercise_set, exercise:)

    assert_equal(exercise.id, exercise_set.exercise.id)
  end

  test "weight must be positive" do
    exercise_set = build(:exercise_set, weight: -1)

    assert_not(exercise_set.valid?)
  end

  test "repetitions must be positive" do
    exercise_set = build(:exercise_set, repetitions: -1)

    assert_not(exercise_set.valid?)
  end
end
