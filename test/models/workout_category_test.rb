# frozen_string_literal:true

require "test_helper"

class WorkoutCategoryTest < ActiveSupport::TestCase
  test "name is required" do
    workout_category = build :workout_category, name: ""
    assert_predicate workout_category, :invalid?
  end
end
