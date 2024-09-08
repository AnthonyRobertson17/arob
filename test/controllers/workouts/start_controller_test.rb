# frozen_string_literal: true

require "test_helper"

module Workouts
  class StartControllerTest < ActionDispatch::IntegrationTest
    def user
      @user ||= create(:user)
    end

    test "update redirects to the workout show page" do
      sign_in(user)
      workout = create(:workout, user:)

      patch(start_workout_url(workout))

      assert_redirected_to(workout_url(workout))

      assert_predicate(workout.reload, :started?)
    end

    test "updating an already started workout should set alert flash" do
      sign_in(user)
      workout = create(:workout, :started, user:)

      patch(start_workout_url(workout))

      assert_redirected_to(workout_url(workout))
      assert_equal("Workout has already started.", flash[:alert])
    end

    test "starting a workout that belongs to another user raises not found" do
      sign_in(user)
      workout = create(:workout)

      patch(start_workout_url(workout))

      assert_response(:not_found)
    end
  end
end
