# frozen_string_literal: true

require "test_helper"

class CreateTestDataCommandTest < ActiveSupport::TestCase
  test "creates 2 users" do
    assert_difference("User.count", 2) do
      CreateTestDataCommand.execute
    end
  end

  test "creates 3 workout_tags" do
    assert_difference("WorkoutTag.count", 3) do
      CreateTestDataCommand.execute
    end
  end

  test "creates 4 exercise_tags" do
    assert_difference("ExerciseTag.count", 4) do
      CreateTestDataCommand.execute
    end
  end

  test "creates 3 workouts" do
    assert_difference("Workout.count", 3) do
      CreateTestDataCommand.execute
    end
  end
end
