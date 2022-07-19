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
  end
end
