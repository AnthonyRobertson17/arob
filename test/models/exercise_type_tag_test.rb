# frozen_string_literal: true

require "test_helper"

class ExerciseTypeTagTest < ActiveSupport::TestCase
  test "can access exercise_type through association" do
    user = create :user
    exercise_type = create :exercise_type, user: user, name: "test_exercise_type"
    exercise_type_tag = create :exercise_type_tag, user: user
    create :exercise_type_tag_assignment, exercise_type: exercise_type, tag: exercise_type_tag

    assert_equal "test_exercise_type", exercise_type_tag.exercise_types.first.name
  end
end
