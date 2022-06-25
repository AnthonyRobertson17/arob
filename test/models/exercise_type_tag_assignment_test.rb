# frozen_string_literal: true

require "test_helper"

class ExerciseTypeTagAssignmentTest < ActiveSupport::TestCase
  test "valid exercise_type tag assignment" do
    user = build :user
    exercise_type = build :exercise_type, user: user
    tag = build :exercise_type_tag, user: user

    exercise_type_tag_assignment = ExerciseTypeTagAssignment.new(exercise_type:, tag:)

    assert_predicate exercise_type_tag_assignment, :valid?
  end

  test "validates exercise_type tag type" do
    user = build :user
    exercise_type = build :exercise_type, user: user
    tag = build :tag

    exercise_type_tag_assignment = ExerciseTypeTagAssignment.new(exercise_type:, tag:)

    assert_predicate exercise_type_tag_assignment, :invalid?
    assert_equal "Tag is the wrong type", exercise_type_tag_assignment.errors.full_messages.first
  end

  test "validates owners of tag and exercise_type match" do
    exercise_type = build :exercise_type
    tag = build :exercise_type_tag

    exercise_type_tag_assignment = ExerciseTypeTagAssignment.new(exercise_type:, tag:)
    assert_predicate exercise_type_tag_assignment, :invalid?

    assert_equal(
      "Tag doesn't share the same user as the exercise type",
      exercise_type_tag_assignment.errors.full_messages.first,
    )
  end
end
