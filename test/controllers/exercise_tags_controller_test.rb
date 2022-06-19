# frozen_string_literal:true

require "test_helper"

class ExerciseTagsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = create :user
    sign_in @user
  end

  test "get index" do
    create :exercise_tag, user: @user, name: "testing exercise tag"

    get exercise_tags_url
    assert_response :success

    assert_select "h5", { text: /testing exercise tag/, count: 1 }
  end

  test "get index doesn't show exercise_tags which don't belong to the current user" do
    create :exercise_tag, name: "should not be able to see this"

    get exercise_tags_url
    assert_response :success

    assert_select "h5", { text: /should not be able to see this/, count: 0 }
  end

  test "get new" do
    get new_exercise_tag_url
    assert_response :success
  end

  test "create exercise_tag redirects to correct exercise_tag" do
    assert_difference("ExerciseTag.count") do
      post exercise_tags_url, params: { exercise_tag: { name: "Random Tag" } }
    end

    assert_redirected_to exercise_tag_url(ExerciseTag.last)
  end

  test "create exercise_tag links to the current_user" do
    post exercise_tags_url, params: { exercise_tag: { name: "Random Tag" } }

    new_exercise_tag = ExerciseTag.for_user(@user).last
    assert_equal "Random Tag", new_exercise_tag.name
  end

  test "show exercise_tag" do
    exercise_tag = create :exercise_tag, user: @user

    get exercise_tag_url(exercise_tag)
    assert_response :success
  end

  test "show exercise_tag raises not found if exercise_tag belongs to another user" do
    exercise_tag = create :exercise_tag

    assert_raises(ActiveRecord::RecordNotFound) do
      get exercise_tag_url(exercise_tag)
    end
  end

  test "get edit" do
    exercise_tag = create :exercise_tag, user: @user

    get edit_exercise_tag_url(exercise_tag)
    assert_response :success
  end

  test "get edit raises not found if exercise_tag is not for the current user" do
    exercise_tag = create :exercise_tag

    assert_raises(ActiveRecord::RecordNotFound) do
      get edit_exercise_tag_url(exercise_tag)
    end
  end

  test "update exercise_tag" do
    exercise_tag = create :exercise_tag, user: @user

    patch exercise_tag_url(exercise_tag), params: { exercise_tag: { name: "New Workout Name" } }
    assert_redirected_to exercise_tag_url(exercise_tag)
  end

  test "update exercise_tag raises not found if exercise_tag belongs to another user" do
    exercise_tag = create :exercise_tag

    assert_raises(ActiveRecord::RecordNotFound) do
      patch exercise_tag_url(exercise_tag), params: { exercise_tag: { name: "New Workout Name" } }
    end
  end

  test "destroy exercise_tag" do
    exercise_tag = create :exercise_tag, user: @user

    assert_difference("ExerciseTag.count", -1) do
      delete exercise_tag_url(exercise_tag)
    end

    assert_redirected_to exercise_tags_url
  end

  test "destroy exercise_tag raises not found if exercise_tag belongs to another user" do
    exercise_tag = create :exercise_tag

    assert_raises(ActiveRecord::RecordNotFound) do
      delete exercise_tag_url(exercise_tag)
    end
  end
end
