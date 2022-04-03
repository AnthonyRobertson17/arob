# frozen_string_literal: true

require "test_helper"

class WorkoutsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @workout = create(:workout)
  end

  test "should get index" do
    get workouts_url
    assert_response :success
  end

  test "should get new" do
    get new_workout_url
    assert_response :success
  end

  test "should create workout" do
    assert_difference("Workout.count") do
      post workouts_url, params: { workout: { name: "New workout name" } }
    end

    assert_redirected_to workout_url(Workout.last)
  end

  test "should show workout" do
    get workout_url(@workout)
    assert_response :success
  end

  test "should get edit" do
    get edit_workout_url(@workout)
    assert_response :success
  end

  test "should update workout" do
    patch workout_url(@workout), params: { workout: { name: "Updated workout name" } }
    assert_redirected_to workout_url(@workout)
    assert_equal "Updated workout name", @workout.reload.name
  end

  test "should destroy workout" do
    assert_difference("Workout.count", -1) do
      delete workout_url(@workout)
    end

    assert_redirected_to workouts_url
  end
end
