# frozen_string_literal: true

require "test_helper"

class ExerciseTypeTest < ActiveSupport::TestCase
  test "name is required" do
    exercise_type = build(:exercise_type, name: "")

    assert_predicate(exercise_type, :invalid?)
  end

  test "can access tags through association" do
    user = create(:user)
    exercise_type_tag = create(:exercise_type_tag, user:, name: "test_tag")
    exercise_type = create(:exercise_type, user:, tags: [exercise_type_tag])

    assert_equal("test_tag", exercise_type.tags.first.name)
  end

  test "can access exercises through association" do
    exercise_type = create(:exercise_type)
    create(:exercise, exercise_type:)
    create(:exercise, exercise_type:)

    assert_equal(2, exercise_type.exercises.count)
  end

  test "for_user scope only returns gyms for the provided user" do
    user = create(:user)
    expected = create(:exercise_type, user:)
    create(:exercise_type)

    exercise_types = ExerciseType.for_user(user)

    assert_predicate(exercise_types, :one?)
    assert_equal(expected.id, exercise_types.first.id)
  end
end
