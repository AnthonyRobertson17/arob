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

  test "create workout redirects to the correct workout" do
    workout_category = create :workout_category, user: @user

    assert_difference("Workout.count") do
      post workouts_url, params: { workout: { name: "New workout name", workout_category_id: workout_category.id } }
    end

    assert_redirected_to workout_url(Workout.last)
  end

  test "create workout links to the current_user" do
    workout_category = create :workout_category, user: @user
    post workouts_url, params: { workout: { name: "New workout name", workout_category_id: workout_category.id } }

    new_workout = Workout.for_user(@user).last
    assert_equal "New workout name", new_workout.name
  end

  test "show workout" do
    get workout_url(@workout)
    assert_response :success
  end

  test "show workout raises not found if the workout belongs to another user" do
    other_workout = create :workout

    assert_raises(ActiveRecord::RecordNotFound) do
      get workout_url(other_workout)
    end
  end

  test "get edit" do
    get edit_workout_url(@workout)
    assert_response :success
  end

  test "get edit raises not found if the workout belongst to another user" do
    other_workout = create :workout

    assert_raises(ActiveRecord::RecordNotFound) do
      get edit_workout_url(other_workout)
    end
  end

  test "update workout" do
    patch workout_url(@workout), params: { workout: { name: "Updated workout name" } }
    assert_redirected_to workout_url(@workout)
    assert_equal "Updated workout name", @workout.reload.name
  end

  test "update workout raises not found if the workout belongs to another user" do
    other_workout = create :workout

    assert_raises(ActiveRecord::RecordNotFound) do
      patch workout_url(other_workout), params: { workout: { name: "Updated workout name" } }
    end
  end

  test "destroy workout" do
    assert_difference("Workout.count", -1) do
      delete workout_url(@workout)
    end

    assert_redirected_to workouts_url
  end

  test "destroy workout raises not found if the workout belongs to another user" do
    other_workout = create :workout

    assert_raises(ActiveRecord::RecordNotFound) do
      delete workout_url(other_workout)
    end
  end
end
