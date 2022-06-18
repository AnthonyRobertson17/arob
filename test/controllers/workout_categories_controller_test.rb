# frozen_string_literal:true

require "test_helper"

class WorkoutCategoriesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = create :user
    sign_in @user
  end

  test "get index" do
    create :workout_category, user: @user, name: "testing workout categories"

    get workout_categories_url
    assert_response :success

    assert_select "h5", { text: /testing workout categories/, count: 1 }
  end

  test "get index doesn't show workout categories which don't belong to the current user" do
    create :workout_category, name: "should not be able to see this"

    get workout_categories_url
    assert_response :success

    assert_select "h5", { text: /should not be able to see this/, count: 0 }
  end

  test "get new" do
    get new_workout_category_url
    assert_response :success
  end

  test "create workout_category redirects to correct workout_category" do
    assert_difference("WorkoutCategory.count") do
      post workout_categories_url, params: { workout_category: { name: "Random Category" } }
    end

    assert_redirected_to workout_category_url(WorkoutCategory.last)
  end

  test "create workout_category links to the current_user" do
    post workout_categories_url, params: { workout_category: { name: "Random Category" } }

    new_workout_category = WorkoutCategory.for_user(@user).last
    assert_equal "Random Category", new_workout_category.name
  end

  test "show workout_category" do
    workout_category = create :workout_category, user: @user

    get workout_category_url(workout_category)
    assert_response :success
  end

  test "show workout_category raises not found if workout_category belongs to another user" do
    workout_category = create :workout_category

    assert_raises(ActiveRecord::RecordNotFound) do
      get workout_category_url(workout_category)
    end
  end

  test "get edit" do
    workout_category = create :workout_category, user: @user

    get edit_workout_category_url(workout_category)
    assert_response :success
  end

  test "get edit raises not found if workout_category is not for the current user" do
    workout_category = create :workout_category

    assert_raises(ActiveRecord::RecordNotFound) do
      get edit_workout_category_url(workout_category)
    end
  end

  test "update workout_category" do
    workout_category = create :workout_category, user: @user

    patch workout_category_url(workout_category), params: { workout_category: { name: "New Workout Name" } }
    assert_redirected_to workout_category_url(workout_category)
  end

  test "update workout_category raises not found if workout_category belongs to another user" do
    workout_category = create :workout_category

    assert_raises(ActiveRecord::RecordNotFound) do
      patch workout_category_url(workout_category), params: { workout_category: { name: "New Workout Name" } }
    end
  end

  test "destroy workout_category" do
    workout_category = create :workout_category, user: @user

    assert_difference("WorkoutCategory.count", -1) do
      delete workout_category_url(workout_category)
    end

    assert_redirected_to workout_categories_url
  end

  test "destroy workout_category raises not found if workout_category belongs to another user" do
    workout_category = create :workout_category

    assert_raises(ActiveRecord::RecordNotFound) do
      delete workout_category_url(workout_category)
    end
  end
end
