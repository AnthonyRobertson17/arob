# frozen_string_literal: true

require "test_helper"

class WorkoutTagTest < ActiveSupport::TestCase
  test "can access workouts through association" do
    user = create(:user)
    workout = create(:workout, user:, name: "test_workout")
    workout_tag = create(:workout_tag, user:)
    create(:workout_tag_assignment, workout:, tag: workout_tag)

    assert_equal("test_workout", workout_tag.workouts.first.name)
  end
end
