# frozen_string_literal: true

require "test_helper"

class WorkoutsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = create :user
    sign_in @user
    @workout = create :workout, user: @user, name: "funny workout"
  end

  test "get index" do
    get workouts_url
    assert_response :success
  end

  test "get index only returns current users workouts" do
    create :workout, name: "should not be shown"

    get workouts_url

    assert_select "p", { text: /funny workout/, count: 1 }
    assert_select "p", { text: /should not be shown/, count: 0 }
  end

  test "get new" do
    get new_workout_url
    assert_response :success
  end

  test "create workout" do
    workout_category = create :workout_category

    assert_difference("Workout.count") do
      post workouts_url, params: { workout: { name: "New workout name", workout_category_id: workout_category.id } }
    end

    new_workout = Workout.last
    assert_equal @user.id, new_workout.user_id

    assert_redirected_to workout_url(new_workout)
  end

  test "show workout" do
    get workout_url(@workout)
    assert_response :success
  end

  test "get edit" do
    get edit_workout_url(@workout)
    assert_response :success
  end

  test "should update workout" do
    patch workout_url(@workout), params: { workout: { name: "Updated workout name" } }
    assert_redirected_to workout_url(@workout)
    assert_equal "Updated workout name", @workout.reload.name
  end

  test "destroy workout" do
    assert_difference("Workout.count", -1) do
      delete workout_url(@workout)
    end

    assert_redirected_to workouts_url
  end
end
