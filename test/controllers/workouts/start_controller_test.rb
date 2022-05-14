# frozen_string_literal: true

require "test_helper"

module Workouts
  class StartControllerTest < ActionDispatch::IntegrationTest
    test "update should start the workout" do
      workout = create :workout

      assert_not workout.reload.started?

      patch start_workout_url(workout)
      assert_redirected_to workout_url(workout)

      assert_predicate workout.reload, :started?
    end
  end
end
