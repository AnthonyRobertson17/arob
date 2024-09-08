# frozen_string_literal:true

require "test_helper"

class WorkoutTagsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = create(:user)
    sign_in(@user)
  end

  test "get index" do
    create(:workout_tag, user: @user, name: "testing workout tag")

    get(workout_tags_url)

    assert_response(:success)

    assert_select("h3", { text: /testing workout tag/, count: 1 })
  end

  test "get index doesn't show workout_tags which don't belong to the current user" do
    create(:workout_tag, name: "should not be able to see this")

    get(workout_tags_url)

    assert_response(:success)

    assert_select("h3", { text: /should not be able to see this/, count: 0 })
  end

  test "get new" do
    get(new_workout_tag_url)

    assert_response(:success)
  end

  test "create workout_tag creates a new record" do
    assert_difference("WorkoutTag.count") do
      post(workout_tags_url, params: { workout_tag: { name: "Random Tag" } })
    end
  end

  test "create workout_tag links new record to the current_user" do
    post(workout_tags_url, params: { workout_tag: { name: "Random Tag" } })

    new_workout_tag = WorkoutTag.for_user(@user).last

    assert_equal("Random Tag", new_workout_tag.name)
  end

  test "create workout_tag with html format redirects to correct workout_tag" do
    post(workout_tags_url, params: { workout_tag: { name: "Random Tag" } })

    assert_redirected_to(workout_tag_url(WorkoutTag.last))
  end

  test "create workout_tag with turbo_stream format response with OK" do
    post(workout_tags_url(format: :turbo_stream), params: { workout_tag: { name: "Random Tag" } })

    assert_response(:ok)
  end

  test "show workout_tag" do
    workout_tag = create(:workout_tag, user: @user)

    get(workout_tag_url(workout_tag))

    assert_response(:success)
  end

  test "show workout_tag returns not found if workout_tag belongs to another user" do
    workout_tag = create(:workout_tag)

    get(workout_tag_url(workout_tag))

    assert_response(:not_found)
  end

  test "get edit" do
    workout_tag = create(:workout_tag, user: @user)

    get(edit_workout_tag_url(workout_tag))

    assert_response(:success)
  end

  test "get edit returns not found if workout_tag is not for the current user" do
    workout_tag = create(:workout_tag)

    get(edit_workout_tag_url(workout_tag))

    assert_response(:not_found)
  end

  test "update workout_tag with html format redirects to show" do
    workout_tag = create(:workout_tag, user: @user)

    patch(workout_tag_url(workout_tag), params: { workout_tag: { name: "New Workout Name" } })

    assert_redirected_to(workout_tag_url(workout_tag))
  end

  test "update workout_tag with turbo_stream format responds with OK" do
    workout_tag = create(:workout_tag, user: @user)

    patch(workout_tag_url(workout_tag, format: :turbo_stream), params: { workout_tag: { name: "New Workout Name" } })

    assert_response(:ok)
  end

  test "update workout_tag returns not found if workout_tag belongs to another user" do
    workout_tag = create(:workout_tag)

    patch(workout_tag_url(workout_tag), params: { workout_tag: { name: "New Workout Name" } })

    assert_response(:not_found)
  end

  test "destroy workout_tag destroys the record" do
    workout_tag = create(:workout_tag, user: @user)

    assert_difference("WorkoutTag.count", -1) do
      delete(workout_tag_url(workout_tag))
    end
  end

  test "destroy workout_tag with html format redirects to workout tag index" do
    workout_tag = create(:workout_tag, user: @user)

    delete(workout_tag_url(workout_tag))

    assert_redirected_to(workout_tags_url)
  end

  test "destroy workout_tag with tubro_stream format response with OK" do
    workout_tag = create(:workout_tag, user: @user)

    delete(workout_tag_url(workout_tag, format: :turbo_stream))

    assert_response(:ok)
  end

  test "destroy workout_tag raises not found if workout_tag belongs to another user" do
    workout_tag = create(:workout_tag)

    delete(workout_tag_url(workout_tag))

    assert_response(:not_found)
  end
end
