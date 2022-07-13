# frozen_string_literal: true

require "test_helper"

class WorkoutTagAssignmentTest < ActiveSupport::TestCase
  test "valid workout tag assignment" do
    user = build(:user)
    workout = build(:workout, user:)
    tag = build(:workout_tag, user:)

    workout_tag_assignment = WorkoutTagAssignment.new(workout:, tag:)

    assert_predicate workout_tag_assignment, :valid?
  end

  test "validates workout tag type" do
    user = build(:user)
    workout = build(:workout, user:)
    tag = build(:tag)

    workout_tag_assignment = WorkoutTagAssignment.new(workout:, tag:)

    assert_predicate workout_tag_assignment, :invalid?
    assert_equal "Tag is the wrong type", workout_tag_assignment.errors.full_messages.first
  end

  test "validates owners of tag and workout match" do
    workout = build(:workout)
    tag = build(:workout_tag)

    workout_tag_assignment = WorkoutTagAssignment.new(workout:, tag:)
    assert_predicate workout_tag_assignment, :invalid?

    assert_equal "Tag doesn't share the same user as the workout", workout_tag_assignment.errors.full_messages.first
  end
end
