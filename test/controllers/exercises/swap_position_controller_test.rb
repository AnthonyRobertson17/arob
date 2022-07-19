# frozen_string_literal: true

require "test_helper"

module Exercises
  class SwapPositionControllerTest < ActionDispatch::IntegrationTest
    setup do
      @user = create(:user)
      sign_in @user
    end

    test "swap positions with an exercise with a smaller position" do
      workout = create(:workout, user: @user)
      exercise1 = create(:exercise, workout:)
      exercise2 = create(:exercise, workout:)

      patch(swap_position_workout_exercise_url(workout, exercise2), params: { position: 0 })

      assert_equal(0, exercise2.reload.position)
      assert_equal(1, exercise1.reload.position)
    end

    test "swap positions with an exercise with a larger position" do
      workout = create(:workout, user: @user)
      exercise1 = create(:exercise, workout:)
      exercise2 = create(:exercise, workout:)

      patch(swap_position_workout_exercise_url(workout, exercise1), params: { position: 1 })

      assert_equal(0, exercise2.reload.position)
      assert_equal(1, exercise1.reload.position)
    end

    test "swap positions with a position at which an exercise does not exist" do
      workout = create(:workout, user: @user)
      exercise = create(:exercise, workout:)

      assert_raises(ActiveRecord::RecordNotFound) do
        patch(swap_position_workout_exercise_url(workout, exercise), params: { position: 5 })
      end
    end

    test "swap positions for a workout that belongs to a different user" do
      workout = create(:workout)
      exercise = create(:exercise, workout:)
      create(:exercise, workout:)

      assert_raises(ActiveRecord::RecordNotFound) do
        patch(swap_position_workout_exercise_url(workout, exercise), params: { position: 1 })
      end
    end
  end
end
