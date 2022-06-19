# frozen_string_literal:true

require "test_helper"

class WorkoutTagsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = create :user
    sign_in @user
  end

  test "get index" do
    create :workout_tag, user: @user, name: "testing workout tag"

    get workout_tags_url
    assert_response :success

    assert_select "h5", { text: /testing workout tag/, count: 1 }
  end

  test "get index doesn't show workout_tags which don't belong to the current user" do
    create :workout_tag, name: "should not be able to see this"

    get workout_tags_url
    assert_response :success

    assert_select "h5", { text: /should not be able to see this/, count: 0 }
  end

  test "get new" do
    get new_workout_tag_url
    assert_response :success
  end

  test "create workout_tag redirects to correct workout_tag" do
    assert_difference("WorkoutTag.count") do
      post workout_tags_url, params: { workout_tag: { name: "Random Tag" } }
    end

    assert_redirected_to workout_tag_url(WorkoutTag.last)
  end

  test "create workout_tag links to the current_user" do
    post workout_tags_url, params: { workout_tag: { name: "Random Tag" } }

    new_workout_tag = WorkoutTag.for_user(@user).last
    assert_equal "Random Tag", new_workout_tag.name
  end

  test "show workout_tag" do
    workout_tag = create :workout_tag, user: @user

    get workout_tag_url(workout_tag)
    assert_response :success
  end

  test "show workout_tag raises not found if workout_tag belongs to another user" do
    workout_tag = create :workout_tag

    assert_raises(ActiveRecord::RecordNotFound) do
      get workout_tag_url(workout_tag)
    end
  end

  test "get edit" do
    workout_tag = create :workout_tag, user: @user

    get edit_workout_tag_url(workout_tag)
    assert_response :success
  end

  test "get edit raises not found if workout_tag is not for the current user" do
    workout_tag = create :workout_tag

    assert_raises(ActiveRecord::RecordNotFound) do
      get edit_workout_tag_url(workout_tag)
    end
  end

  test "update workout_tag" do
    workout_tag = create :workout_tag, user: @user

    patch workout_tag_url(workout_tag), params: { workout_tag: { name: "New Workout Name" } }
    assert_redirected_to workout_tag_url(workout_tag)
  end

  test "update workout_tag raises not found if workout_tag belongs to another user" do
    workout_tag = create :workout_tag

    assert_raises(ActiveRecord::RecordNotFound) do
      patch workout_tag_url(workout_tag), params: { workout_tag: { name: "New Workout Name" } }
    end
  end

  test "destroy workout_tag" do
    workout_tag = create :workout_tag, user: @user

    assert_difference("WorkoutTag.count", -1) do
      delete workout_tag_url(workout_tag)
    end

    assert_redirected_to workout_tags_url
  end

  test "destroy workout_tag raises not found if workout_tag belongs to another user" do
    workout_tag = create :workout_tag

    assert_raises(ActiveRecord::RecordNotFound) do
      delete workout_tag_url(workout_tag)
    end
  end
end
