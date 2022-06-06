# frozen_string_literal:true

require "test_helper"

class WorkoutCategoryTest < ActiveSupport::TestCase
  test "name is required" do
    workout_category = build :workout_category, name: ""
    assert_predicate workout_category, :invalid?
  end

  test "for_user scope only returns workout_categories for the provided user" do
    user = create :user
    create :workout_category
    create :workout_category, user: user

    assert_predicate WorkoutCategory.for_user(user), :one?
  end
end
