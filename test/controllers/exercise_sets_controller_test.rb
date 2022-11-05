# frozen_string_literal:true

require "test_helper"

class ExerciseSetsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = create(:user)
    sign_in(@user)
    @workout = create(:workout, user: @user)
    @exercise_type = create(:exercise_type, user: @user)
    @exercise = create(:exercise, workout: @workout, exercise_type: @exercise_type)
  end

  def workout
    @workout ||= create(:workout, user: @user)
  end

  def exercise_type
    @exercise_type ||= create(:exercise_type, user: @user)
  end

  def exercise
    @exercise ||= create(:exercise, workout:, exercise_type:)
  end

  test "get new" do
    get(new_workout_exercise_exercise_set_url(workout, exercise))

    assert_response(:success)
  end

  test "create exercise_set creates a new record" do
    assert_difference("ExerciseSet.count") do
      post(
        workout_exercise_exercise_sets_url(workout, exercise),
        params: {
          exercise_set: {
            weight: 25.2,
            repetitions: 10,
          },
        },
      )
    end
  end

  test "create exercise_set links new record to the correct exercise" do
    post(
      workout_exercise_exercise_sets_url(workout, exercise),
      params: {
        exercise_set: {
          weight: 25.2,
          repetitions: 10,
        },
      },
    )

    new_exercise_set = exercise.exercise_sets.first

    assert_in_delta(25.2, new_exercise_set.weight)
  end

  test "create exercise_set with html format redirects to the related workout" do
    post(
      workout_exercise_exercise_sets_url(workout, exercise),
      params: {
        exercise_set: {
          weight: 25.2,
          repetitions: 10,
        },
      },
    )

    assert_redirected_to(workout_url(workout))
  end

  test "create workout_tag with turbo_stream format response with OK" do
    post(
      workout_exercise_exercise_sets_url(workout, exercise, format: :turbo_stream),
      params: {
        exercise_set: {
          weight: 25.2,
          repetitions: 10,
        },
      },
    )

    assert_response(:ok)
  end

  test "get edit" do
    exercise_set = create(:exercise_set, exercise:)

    get(edit_workout_exercise_exercise_set_url(workout, exercise, exercise_set))

    assert_response(:success)
  end

  test "get edit raises not found if corresponding workout does not belong to the current user" do
    other_user = create(:user)
    other_workout = create(:workout, user: other_user)
    other_exercise_type = create(:exercise_type, user: other_user)
    other_exercise = create(:exercise, exercise_type: other_exercise_type, workout: other_workout)
    other_exercise_set = create(:exercise_set, exercise: other_exercise)

    assert_raises(ActiveRecord::RecordNotFound) do
      get(edit_workout_exercise_exercise_set_url(other_workout, other_exercise, other_exercise_set))
    end
  end

  test "update exercise_set with html format redirects to the associated workout" do
    exercise_set = create(:exercise_set, exercise:)

    patch(
      workout_exercise_exercise_set_url(workout, exercise, exercise_set),
      params: {
        exercise_set: { weight: 55.5 },
      },
    )

    assert_redirected_to(workout_url(workout))
  end

  test "update exercise_set with turbo_stream format responds with OK" do
    exercise_set = create(:exercise_set, exercise:)

    patch(
      workout_exercise_exercise_set_url(workout, exercise, exercise_set, format: :turbo_stream),
      params: {
        exercise_set: { weight: 55.5 },
      },
    )

    assert_response :ok
  end

  test "update exercise_set raises not found if associated workout belongs to another user" do
    other_user = create(:user)
    other_workout = create(:workout, user: other_user)
    other_exercise_type = create(:exercise_type, user: other_user)
    other_exercise = create(:exercise, exercise_type: other_exercise_type, workout: other_workout)
    other_exercise_set = create(:exercise_set, exercise: other_exercise)

    assert_raises(ActiveRecord::RecordNotFound) do
      patch(
        workout_exercise_exercise_set_url(other_workout, other_exercise, other_exercise_set),
        params: {
          exercise_set: { weight: 55.5 },
        },
      )
    end
  end

  test "destroy exercise_set destroys the record" do
    exercise_set = create(:exercise_set, exercise:)

    assert_difference("ExerciseSet.count", -1) do
      delete(workout_exercise_exercise_set_url(workout, exercise, exercise_set))
    end
  end

  test "destroy exercise_set with html format redirects to the associated workout page" do
    exercise_set = create(:exercise_set, exercise:)

    delete(workout_exercise_exercise_set_url(workout, exercise, exercise_set))

    assert_redirected_to(workout_url(workout))
  end

  test "destroy exercise_set with tubro_stream format response with OK" do
    exercise_set = create(:exercise_set, exercise:)

    delete(workout_exercise_exercise_set_url(workout, exercise, exercise_set, format: :turbo_stream))

    assert_response(:ok)
  end

  test "destroy exercise_set raises not found if associated workout belongs to another user" do
    other_user = create(:user)
    other_workout = create(:workout, user: other_user)
    other_exercise_type = create(:exercise_type, user: other_user)
    other_exercise = create(:exercise, exercise_type: other_exercise_type, workout: other_workout)
    other_exercise_set = create(:exercise_set, exercise: other_exercise)

    assert_raises(ActiveRecord::RecordNotFound) do
      delete(workout_exercise_exercise_set_url(other_workout, other_exercise, other_exercise_set))
    end
  end
end
