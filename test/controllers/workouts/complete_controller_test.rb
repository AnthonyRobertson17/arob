# frozen_string_literal: true

require "test_helper"

module Workouts
  class CompleteControllerTest < ActionDispatch::IntegrationTest
    setup do
      user = create(:user)
      sign_in user
    end

    test "update redirects to the workout show page" do
      workout = create(:workout, :started)

      patch complete_workout_url(workout)

      assert_redirected_to workout_url(workout)

      assert_predicate workout.reload, :completed?
    end

    test "updating an already completed workout should set alert flash" do
      workout = create(:workout, :completed)

      patch complete_workout_url(workout)

      assert_redirected_to workout_url(workout)
      assert_equal "Workout has already been completed.", flash[:alert]
    end

    test "updating a not started workout should set alert flash" do
      workout = create(:workout)

      patch complete_workout_url(workout)

      assert_redirected_to workout_url(workout)
      assert_equal "Workout has not been started.", flash[:alert]
    end
  end
end
