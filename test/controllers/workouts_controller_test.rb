# frozen_string_literal: true

require "test_helper"

class WorkoutsControllerTest < ActionDispatch::IntegrationTest
  def user
    @user ||= create(:user)
  end

  setup do
    sign_in(user)
  end

  test "get index" do
    create(:workout, user:)

    get(workouts_url)

    assert_response(:success)
  end

  test "get index only returns current users workouts" do
    create(:workout, user:, name: "funny workout")
    create(:workout, name: "should not be shown")

    get(workouts_url)

    assert_select("h3", { text: /funny workout/, count: 1 })
    assert_select("h3", { text: /should not be shown/, count: 0 })
  end

  test "get index lists workouts in reverse chronological order" do
    create(:workout, :completed, user:, name: "AAA")
    create(:workout, :completed, user:, name: "BBB")
    create(:workout, :completed, user:, name: "CCC")

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
    create(:workout_tag, user:, name: "CCC")
    create(:workout_tag, user:, name: "bbb")
    create(:workout_tag, user:, name: "AAA")

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
      create(:workout_tag, user:),
      create(:workout_tag, user:),
    ].map(&:id)

    post(workouts_url, params: { workout: { name: "Test", tag_ids: workout_tag_ids } })

    associated_tag_ids = Workout.last.tags.map(&:id)

    workout_tag_ids.each do |id|
      assert_includes(associated_tag_ids, id)
    end
  end

  test "show workout includes started_at time" do
    workout = create(:workout, :started, user:)

    get(workout_url(workout))

    assert_response(:success)
    assert_select("td", { text: /#{workout.started_at.to_fs(:timestamp)}/, count: 1 })
  end

  test "show workout includes completed_at time" do
    workout = create(:workout, :completed, user:)

    get(workout_url(workout))

    assert_response(:success)
    assert_select("td", { text: /#{workout.completed_at.to_fs(:timestamp)}/, count: 1 })
  end

  test "show workout includes exercises for workout" do
    workout = create(:workout, user:)
    exercise_type = create(:exercise_type, user:, name: "test exercise type")
    create(:exercise, workout:, exercise_type:)

    get(workout_url(workout))

    assert_response(:success)

    assert_select("h3", { text: /Exercises/, count: 1 })
    assert_select("h4", { text: /test exercise type/, count: 1 })
  end

  test "show workout raises not found if the workout belongs to another user" do
    workout = create(:workout)

    assert_raises(ActiveRecord::RecordNotFound) do
      get(workout_url(workout))
    end
  end

  test "get edit" do
    workout = create(:workout, user:)
    get(edit_workout_url(workout))

    assert_response(:success)
  end

  test "edit form lists workout tags in case insensitive alphabetical order" do
    workout = create(:workout, user:)
    create(:workout_tag, user:, name: "CCC")
    create(:workout_tag, user:, name: "bbb")
    create(:workout_tag, user:, name: "AAA")

    get(edit_workout_url(workout))

    a = response.body.index("AAA")
    b = response.body.index("bbb")
    c = response.body.index("CCC")

    assert(a < b, "workout tags are not in alphabetical order")
    assert(b < c, "workout tags are not in alphabetical order")
  end

  test "get edit raises not found if the workout belongst to another user" do
    workout = create(:workout)

    assert_raises(ActiveRecord::RecordNotFound) do
      get(edit_workout_url(workout))
    end
  end

  test "update workout name" do
    workout = create(:workout, user:)

    patch(workout_url(workout), params: { workout: { name: "Updated workout name" } })

    workout.reload

    assert_equal("Updated workout name", workout.name)
  end

  test "update workout started_at time" do
    workout = create(:workout, :started, user:)
    started_at = 2.hours.ago.round
    patch(workout_url(workout), params: { workout: { started_at: } })

    workout.reload

    assert_equal(started_at, workout.started_at)
  end

  test "update workout completed_at time" do
    workout = create(:workout, :completed, user:)
    completed_at = 1.hour.ago.round
    patch(workout_url(workout), params: { workout: { completed_at: } })

    workout.reload

    assert_equal(completed_at, workout.completed_at)
  end

  test "update workout with html format redirects to the workout show page" do
    workout = create(:workout, user:)
    patch(workout_url(workout), params: { workout: { name: "Updated workout name" } })

    assert_redirected_to(workout_url(workout))
  end

  test "update workout with turbo_stream format responds with OK" do
    workout = create(:workout, user:)
    patch(workout_url(workout, format: :turbo_stream), params: { workout: { name: "Updated workout name" } })

    assert_response(:ok)
  end

  test "can update workout tags" do
    workout = create(:workout, user:)
    workout_tag_ids = [
      create(:workout_tag, user:),
      create(:workout_tag, user:),
    ].map(&:id)

    patch(workout_url(workout), params: { workout: { name: "funny workout", tag_ids: workout_tag_ids } })

    associated_tag_ids = Workout.last.tags.map(&:id)

    workout_tag_ids.each do |id|
      assert_includes(associated_tag_ids, id)
    end
  end

  test "update workout raises not found if the workout belongs to another user" do
    workout = create(:workout)

    assert_raises(ActiveRecord::RecordNotFound) do
      patch(workout_url(workout), params: { workout: { name: "Updated workout name" } })
    end
  end

  test "destroy workout" do
    workout = create(:workout, user:)
    assert_difference("Workout.count", -1) do
      delete(workout_url(workout))
    end

    assert_redirected_to(workouts_url)
  end

  test "destroy workout raises not found if the workout belongs to another user" do
    workout = create(:workout)

    assert_raises(ActiveRecord::RecordNotFound) do
      delete(workout_url(workout))
    end
  end
end
