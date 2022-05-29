# frozen_string_literal: true

require "test_helper"

module Workouts
  class StartControllerTest < ActionDispatch::IntegrationTest
    setup do
      user = create :user
      sign_in user
    end

    test "update redirects to the workout show page" do
      workout = create :workout

      patch start_workout_url(workout)
      assert_redirected_to workout_url(workout)
      assert_equal "Workout was successfully started.", flash[:notice]

      assert_predicate workout.reload, :started?
    end

    test "updating an already started workout should set alert flash" do
      workout = create :workout, :started

      patch start_workout_url(workout)

      assert_redirected_to workout_url(workout)
      assert_equal "Workout has already started.", flash[:alert]
    end
  end
end
