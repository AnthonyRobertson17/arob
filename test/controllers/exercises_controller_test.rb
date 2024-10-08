# frozen_string_literal:true

require "test_helper"

class ExercisesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = create(:user)
    sign_in(@user)
    @workout = create(:workout, user: @user)
    @exercise_type = create(:exercise_type, user: @user)
  end

  test "get new" do
    get(new_workout_exercise_url(@workout))

    assert_response(:success)
  end

  test "create exercise creates a new record" do
    assert_difference("Exercise.count") do
      post(
        workout_exercises_url(@workout),
        params: {
          exercise: {
            exercise_type_id: @exercise_type.id,
            note: "this is a test note",
          },
        },
      )
    end
  end

  test "create exercise links new record to the correct workout" do
    post(
      workout_exercises_url(@workout),
      params: {
        exercise: {
          exercise_type_id: @exercise_type.id,
          note: "this is a test note",
        },
      },
    )

    new_exercise = @workout.exercises.first

    assert_equal(@exercise_type.id, new_exercise.exercise_type_id)
  end

  test "create exercise with html format redirects to the related workout" do
    post(
      workout_exercises_url(@workout),
      params: {
        exercise: {
          exercise_type_id: @exercise_type.id,
          note: "this is a test note",
        },
      },
    )

    assert_redirected_to(workout_url(@workout))
  end

  test "create exercise with turbo_stream format response with OK" do
    post(
      workout_exercises_url(@workout, format: :turbo_stream),
      params: {
        exercise: {
          exercise_type_id: @exercise_type.id,
          note: "this is a test note",
        },
      },
    )

    assert_response(:ok)
  end

  test "get edit" do
    exercise = create(:exercise, exercise_type: @exercise_type, workout: @workout)

    get(edit_workout_exercise_url(@workout, exercise))

    assert_response(:success)
  end

  test "get edit returns not found if corresponding workout does not belong to the current user" do
    other_user = create(:user)
    other_workout = create(:workout, user: other_user)
    other_exercise_type = create(:exercise_type, user: other_user)
    other_exercise = create(:exercise, exercise_type: other_exercise_type, workout: other_workout)

    get(edit_workout_exercise_url(other_workout, other_exercise))

    assert_response(:not_found)
  end

  test "update exercise actually updates the record" do
    exercise = create(:exercise, exercise_type: @exercise_type, workout: @workout)
    new_exercise_type = create(:exercise_type, user: @user)

    patch(
      workout_exercise_url(@workout, exercise),
      params: {
        exercise: {
          exercise_type_id: new_exercise_type.id,
          note: "this is a test note",
        },
      },
    )

    exercise.reload

    assert_equal(new_exercise_type.id, exercise.exercise_type.id)
    assert_equal("this is a test note", exercise.note)
  end

  test "update exercise with html format redirects to the associated workout" do
    exercise = create(:exercise, exercise_type: @exercise_type, workout: @workout)
    new_exercise_type = create(:exercise_type, user: @user)

    patch(
      workout_exercise_url(@workout, exercise),
      params: {
        exercise: {
          exercise_type_id: new_exercise_type.id,
          note: "this is a test note",
        },
      },
    )

    assert_redirected_to(workout_url(@workout))
  end

  test "update exercise with turbo_stream format responds with OK" do
    exercise = create(:exercise, exercise_type: @exercise_type, workout: @workout)
    new_exercise_type = create(:exercise_type, user: @user)

    patch(
      workout_exercise_url(@workout, exercise, format: :turbo_stream),
      params: {
        workout_id: @workout.id,
        exercise: {
          exercise_type_id: new_exercise_type.id,
          note: "this is a test note",
        },
      },
    )

    assert_response(:ok)
  end

  test "update exercise returns not found if associated workout belongs to another user" do
    other_user = create(:user)
    other_workout = create(:workout, user: other_user)
    other_exercise_type = create(:exercise_type, user: other_user)
    other_exercise = create(:exercise, exercise_type: other_exercise_type, workout: other_workout)

    patch(
      workout_exercise_url(other_workout, other_exercise),
      params: {
        exercise: {
          exercise_type_id: 123,
          note: "this is a test note",
        },
      },
    )

    assert_response(:not_found)
  end

  test "destroy exercise destroys the record" do
    exercise = create(:exercise, exercise_type: @exercise_type, workout: @workout)

    assert_difference("Exercise.count", -1) do
      delete(workout_exercise_url(@workout, exercise))
    end
  end

  test "destroy exercise with html format redirects to the associated workout page" do
    exercise = create(:exercise, exercise_type: @exercise_type, workout: @workout)

    delete(workout_exercise_url(@workout, exercise))

    assert_redirected_to(workout_url(@workout))
  end

  test "destroy exercise with tubro_stream format response with OK" do
    exercise = create(:exercise, exercise_type: @exercise_type, workout: @workout)

    delete(workout_exercise_url(@workout, exercise, format: :turbo_stream))

    assert_response(:ok)
  end

  test "destroy exercise returns not found if associated workout belongs to another user" do
    other_user = create(:user)
    other_workout = create(:workout, user: other_user)
    other_exercise_type = create(:exercise_type, user: other_user)
    other_exercise = create(:exercise, exercise_type: other_exercise_type, workout: other_workout)

    delete(workout_exercise_url(other_workout, other_exercise))

    assert_response(:not_found)
  end
end
