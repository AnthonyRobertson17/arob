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

  test "creates 4 exercise_type_tags" do
    assert_difference("ExerciseTypeTag.count", 4) do
      CreateTestDataCommand.execute
    end
  end

  test "creates 4 workouts" do
    assert_difference("Workout.count", 4) do
      CreateTestDataCommand.execute
    end
  end

  test "creates 4 exercise_types" do
    assert_difference("ExerciseType.count", 4) do
      CreateTestDataCommand.execute
    end
  end

  test "creates 2 exercises" do
    assert_difference("Exercise.count", 2) do
      CreateTestDataCommand.execute
    end
  end

  test "creates 8 exercise_sets" do
    assert_difference("ExerciseSet.count", 8) do
      CreateTestDataCommand.execute
    end
  end

  test "creates 4 wishlists" do
    assert_difference("Wishlist.count", 4) do
      CreateTestDataCommand.execute
    end
  end

  test "creates 8 wishlist_items" do
    assert_difference("WishlistItem.count", 8) do
      CreateTestDataCommand.execute
    end
  end

  test "creates 8 links" do
    assert_difference("Link.count", 8) do
      CreateTestDataCommand.execute
    end
  end

  test "creates 4 gyms" do
    assert_difference("Gym.count", 4) do
      CreateTestDataCommand.execute
    end
  end
end
