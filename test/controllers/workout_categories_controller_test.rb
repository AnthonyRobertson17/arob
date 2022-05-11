# frozen_string_literal:true

require "test_helper"

class WorkoutCategoriesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @workout_category = create(:workout_category)
  end

  test "should get index" do
    get workout_categories_url
    assert_response :success
  end

  test "should get new" do
    get new_workout_category_url
    assert_response :success
  end

  test "should create workout_category" do
    assert_difference("WorkoutCategory.count") do
      post workout_categories_url, params: { workout_category: { name: "Random Category" } }
    end

    assert_redirected_to workout_category_url(WorkoutCategory.last)
  end

  test "should show workout_category" do
    get workout_category_url(@workout_category)
    assert_response :success
  end

  test "should get edit" do
    get edit_workout_category_url(@workout_category)
    assert_response :success
  end

  test "should update workout_category" do
    patch workout_category_url(@workout_category), params: { workout_category: { name: "New Workout Name" } }
    assert_redirected_to workout_category_url(@workout_category)
  end

  test "should destroy workout_category" do
    assert_difference("WorkoutCategory.count", -1) do
      delete workout_category_url(@workout_category)
    end

    assert_redirected_to workout_categories_url
  end
end