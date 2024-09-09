# frozen_string_literal: true

require "test_helper"

module Workouts
  class CompleteControllerTest < ActionDispatch::IntegrationTest
    def user
      @user ||= create(:user)
    end

    test "update redirects to the workout show page" do
      sign_in(user)
      workout = create(:workout, :started, user:)

      patch(complete_workout_url(workout))

      assert_redirected_to(workout_url(workout))

      assert_predicate(workout.reload, :completed?)
    end

    test "updating an already completed workout should set alert flash" do
      sign_in(user)
      workout = create(:workout, :completed, user:)

      patch(complete_workout_url(workout))

      assert_redirected_to(workout_url(workout))
      assert_equal("Workout has already been completed.", flash[:alert])
    end

    test "updating a not started workout should set alert flash" do
      sign_in(user)
      workout = create(:workout, user:)

      patch(complete_workout_url(workout))

      assert_redirected_to(workout_url(workout))
      assert_equal("Workout has not been started.", flash[:alert])
    end

    test "trying to complete a workout that belongs to another user returns not found" do
      sign_in(user)
      workout = create(:workout, :started)

      patch(complete_workout_url(workout))

      assert_response(:not_found)
    end
  end
end
