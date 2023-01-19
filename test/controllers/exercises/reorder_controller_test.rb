# frozen_string_literal: true

require "test_helper"

module Exercises
  class ReorderControllerTest < ActionDispatch::IntegrationTest
    setup do
      @user = create(:user)
      sign_in @user
    end

    test "#move_higher with an exercise in a higher position" do
      workout = create(:workout, user: @user)
      exercise1 = create(:exercise, workout:)
      exercise2 = create(:exercise, workout:)

      patch(move_higher_workout_exercise_url(workout, exercise2))

      assert_equal(0, exercise2.reload.position)
      assert_equal(1, exercise1.reload.position)
    end

    test "#move_higher when the first exercise is specified should return 422 - Unprocessable Entity" do
      workout = create(:workout, user: @user)
      exercise = create(:exercise, workout:)

      patch(move_higher_workout_exercise_url(workout, exercise))

      assert_response(:unprocessable_entity)
    end

    test "#move_lower with an exercise in a lower position" do
      workout = create(:workout, user: @user)
      exercise1 = create(:exercise, workout:)
      exercise2 = create(:exercise, workout:)

      patch(move_lower_workout_exercise_url(workout, exercise1))

      assert_equal(0, exercise2.reload.position)
      assert_equal(1, exercise1.reload.position)
    end

    test "#move_lower when the last exercise is specified should return 422 - Unprocessable Entity" do
      workout = create(:workout, user: @user)
      exercise = create(:exercise, workout:)

      patch(move_lower_workout_exercise_url(workout, exercise))

      assert_response(:unprocessable_entity)
    end
  end
end
