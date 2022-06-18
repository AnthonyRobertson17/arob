# frozen_string_literal: true

require "test_helper"

class ExerciseCategoryTest < ActiveSupport::TestCase
  test "name is required" do
    exercise_category = build :exercise_category, name: ""
    assert_predicate exercise_category, :invalid?
  end

  test "for_user scope only returns exercise_categories for the provided user" do
    user = create :user
    create :exercise_category
    create :exercise_category, user: user

    assert_predicate ExerciseCategory.for_user(user), :one?
  end
end
