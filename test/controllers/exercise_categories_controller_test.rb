# frozen_string_literal: true

require "test_helper"

class ExerciseCategoriesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = create :user
    sign_in @user
  end

  test "get index" do
    create :exercise_category, user: @user, name: "testing exercise categories"

    get exercise_categories_url
    assert_response :success

    assert_select "h5", { text: /testing exercise categories/, count: 1 }
  end

  test "get index doesn't show exercise categories which don't belong to the current user" do
    create :exercise_category, name: "should not be able to see this"

    get exercise_categories_url
    assert_response :success

    assert_select "h5", { text: /should not be able to see this/, count: 0 }
  end

  test "get new" do
    get new_exercise_category_url
    assert_response :success
  end

  test "create exercise_category redirects to correct exercise_category" do
    assert_difference("ExerciseCategory.count") do
      post exercise_categories_url, params: { exercise_category: { name: "Random Category" } }
    end

    assert_redirected_to exercise_category_url(ExerciseCategory.last)
  end

  test "create exercise_category links to the current_user" do
    post exercise_categories_url, params: { exercise_category: { name: "Random Category" } }

    new_exercise_category = ExerciseCategory.for_user(@user).last
    assert_equal "Random Category", new_exercise_category.name
  end

  test "show exercise_category" do
    exercise_category = create :exercise_category, user: @user

    get exercise_category_url(exercise_category)
    assert_response :success
  end

  test "show exercise_category raises not found if exercise_category belongs to another user" do
    exercise_category = create :exercise_category

    assert_raises(ActiveRecord::RecordNotFound) do
      get exercise_category_url(exercise_category)
    end
  end

  test "get edit" do
    exercise_category = create :exercise_category, user: @user

    get edit_exercise_category_url(exercise_category)
    assert_response :success
  end

  test "get edit raises not found if exercise_category is not for the current user" do
    exercise_category = create :exercise_category

    assert_raises(ActiveRecord::RecordNotFound) do
      get edit_exercise_category_url(exercise_category)
    end
  end

  test "update exercise_category" do
    exercise_category = create :exercise_category, user: @user

    patch exercise_category_url(exercise_category), params: { exercise_category: { name: "New Exercise Name" } }
    assert_redirected_to exercise_category_url(exercise_category)
  end

  test "update exercise_category raises not found if exercise_category belongs to another user" do
    exercise_category = create :exercise_category

    assert_raises(ActiveRecord::RecordNotFound) do
      patch exercise_category_url(exercise_category), params: { exercise_category: { name: "New Exercise Name" } }
    end
  end

  test "destroy exercise_category" do
    exercise_category = create :exercise_category, user: @user

    assert_difference("ExerciseCategory.count", -1) do
      delete exercise_category_url(exercise_category)
    end

    assert_redirected_to exercise_categories_url
  end

  test "destroy exercise_category raises not found if exercise_category belongs to another user" do
    exercise_category = create :exercise_category

    assert_raises(ActiveRecord::RecordNotFound) do
      delete exercise_category_url(exercise_category)
    end
  end
end
