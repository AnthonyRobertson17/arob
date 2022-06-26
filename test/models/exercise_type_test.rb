# frozen_string_literal: true

require "test_helper"

class ExerciseTypeTest < ActiveSupport::TestCase
  test "name is required" do
    exercise_type = build :exercise_type, name: ""
    assert_predicate exercise_type, :invalid?
  end

  test "can access tags through association" do
    user = create :user
    exercise_type_tag = create :exercise_type_tag, user: user, name: "test_tag"
    exercise_type = create :exercise_type, user:, tags: [exercise_type_tag]

    assert_equal "test_tag", exercise_type.tags.first.name
  end

  test "for_user scope only returns exercise_types for the provided user" do
    user = create :user
    create :exercise_type
    create :exercise_type, user: user

    assert_predicate ExerciseType.for_user(user), :one?
  end
end