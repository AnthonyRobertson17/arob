# frozen_string_literal:true

require "test_helper"

class WorkoutCategoriesControllerTest < ActionDispatch::IntegrationTest
  setup do
    user = create :user
    sign_in user
    @workout_category = create(:workout_category)
  end

  test "get index" do
    get workout_categories_url
    assert_response :success
  end

  test "get new" do
    get new_workout_category_url
    assert_response :success
  end

  test "create workout_category" do
    assert_difference("WorkoutCategory.count") do
      post workout_categories_url, params: { workout_category: { name: "Random Category" } }
    end

    assert_redirected_to workout_category_url(WorkoutCategory.last)
  end

  test "show workout_category" do
    get workout_category_url(@workout_category)
    assert_response :success
  end

  test "get edit" do
    get edit_workout_category_url(@workout_category)
    assert_response :success
  end

  test "update workout_category" do
    patch workout_category_url(@workout_category), params: { workout_category: { name: "New Workout Name" } }
    assert_redirected_to workout_category_url(@workout_category)
  end

  test "destroy workout_category" do
    assert_difference("WorkoutCategory.count", -1) do
      delete workout_category_url(@workout_category)
    end

    assert_redirected_to workout_categories_url
  end
end
