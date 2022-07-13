# frozen_string_literal: true

require "test_helper"

class WorkoutsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = create(:user)
    sign_in(@user)
    @workout = create(:workout, user: @user, name: "funny workout")
  end

  test "get index" do
    get(workouts_url)
    assert_response(:success)
  end

  test "get index only returns current users workouts" do
    create(:workout, name: "should not be shown")

    get(workouts_url)

    assert_select("h5", { text: /funny workout/, count: 1 })
    assert_select("h5", { text: /should not be shown/, count: 0 })
  end

  test "get index lists workouts in reverse chronological order" do
    create(:workout, :completed, user: @user, name: "AAA")
    create(:workout, :completed, user: @user, name: "BBB")
    create(:workout, :completed, user: @user, name: "CCC")

    get(workouts_url)

    first = response.body.index("AAA")
    second = response.body.index("BBB")
    third = response.body.index("CCC")

    assert(first > second, "workouts are not in reverse chronological order")
    assert(second > third, "workouts are not in reverse chronological order")
  end

  test "get new" do
    get(new_workout_url)
    assert_response(:success)
  end

  test "new form lists workout tags in case insensitive alphabetical order" do
    create(:workout_tag, name: "CCC", user: @user)
    create(:workout_tag, name: "bbb", user: @user)
    create(:workout_tag, name: "AAA", user: @user)

    get(new_workout_url)

    a = response.body.index("AAA")
    b = response.body.index("bbb")
    c = response.body.index("CCC")

    assert(a < b, "workout tags are not in alphabetical order")
    assert(b < c, "workout tags are not in alphabetical order")
  end

  test "create workout redirects to the correct workout" do
    assert_difference("Workout.count") do
      post(workouts_url, params: { workout: { name: "New workout name" } })
    end

    assert_redirected_to(workout_url(Workout.last))
  end

  test "create workout links to the current_user" do
    post(workouts_url, params: { workout: { name: "New workout name" } })

    new_workout = Workout.for_user(@user).last
    assert_equal("New workout name", new_workout.name)
  end

  test "create workout links the tags based on the selected tag ids" do
    workout_tag_ids = [
      create(:workout_tag, user: @user),
      create(:workout_tag, user: @user),
    ].map(&:id)

    post(workouts_url, params: { workout: { name: "Test", tag_ids: workout_tag_ids } })

    associated_tag_ids = Workout.last.tags.map(&:id)

    workout_tag_ids.each do |id|
      assert_includes(associated_tag_ids, id)
    end
  end

  test "show workout includes started_at time" do
    workout = create(:workout, :started, user: @user)

    get(workout_url(workout))

    assert_response(:success)
    assert_select("td", { text: /#{workout.started_at.to_fs(:timestamp)}/, count: 1 })
  end

  test "show workout includes completed_at time" do
    workout = create(:workout, :completed, user: @user)

    get(workout_url(workout))

    assert_response(:success)
    assert_select("td", { text: /#{workout.completed_at.to_fs(:timestamp)}/, count: 1 })
  end

  test "show workout includes exercises for workout" do
    exercise_type = create(:exercise_type, user: @user, name: "test exercise type")
    create(:exercise, workout: @workout, exercise_type:)

    get(workout_url(@workout))
    assert_response(:success)

    assert_select("h3", { text: /Exercises/, count: 1 })
    assert_select("h4", { text: /test exercise type/, count: 1 })
  end

  test "show workout raises not found if the workout belongs to another user" do
    other_workout = create(:workout)

    assert_raises(ActiveRecord::RecordNotFound) do
      get(workout_url(other_workout))
    end
  end

  test "get edit" do
    get(edit_workout_url(@workout))
    assert_response(:success)
  end

  test "edit form lists workout tags in case insensitive alphabetical order" do
    create(:workout_tag, name: "CCC", user: @user)
    create(:workout_tag, name: "bbb", user: @user)
    create(:workout_tag, name: "AAA", user: @user)

    get(edit_workout_url(@workout))

    a = response.body.index("AAA")
    b = response.body.index("bbb")
    c = response.body.index("CCC")

    assert(a < b, "workout tags are not in alphabetical order")
    assert(b < c, "workout tags are not in alphabetical order")
  end

  test "get edit raises not found if the workout belongst to another user" do
    other_workout = create(:workout)

    assert_raises(ActiveRecord::RecordNotFound) do
      get(edit_workout_url(other_workout))
    end
  end

  test "update workout" do
    patch(workout_url(@workout), params: { workout: { name: "Updated workout name" } })
    assert_redirected_to(workout_url(@workout))
    assert_equal("Updated workout name", @workout.reload.name)
  end

  test "can update workout tags" do
    workout_tag_ids = [
      create(:workout_tag, user: @user),
      create(:workout_tag, user: @user),
    ].map(&:id)

    patch(workout_url(@workout), params: { workout: { name: "funny workout", tag_ids: workout_tag_ids } })

    associated_tag_ids = Workout.last.tags.map(&:id)

    workout_tag_ids.each do |id|
      assert_includes(associated_tag_ids, id)
    end
  end

  test "update workout raises not found if the workout belongs to another user" do
    other_workout = create(:workout)

    assert_raises(ActiveRecord::RecordNotFound) do
      patch(workout_url(other_workout), params: { workout: { name: "Updated workout name" } })
    end
  end

  test "destroy workout" do
    assert_difference("Workout.count", -1) do
      delete(workout_url(@workout))
    end

    assert_redirected_to(workouts_url)
  end

  test "destroy workout raises not found if the workout belongs to another user" do
    other_workout = create(:workout)

    assert_raises(ActiveRecord::RecordNotFound) do
      delete(workout_url(other_workout))
    end
  end
end
