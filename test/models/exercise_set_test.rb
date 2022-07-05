# frozen_string_literal: true

require "test_helper"

class ExerciseSetTest < ActiveSupport::TestCase
  test "can access exercise through association" do
    exercise = create(:exercise)
    exercise_set = create(:exercise_set, exercise:)

    assert_equal(exercise.id, exercise_set.exercise.id)
  end
end
