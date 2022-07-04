# frozen_string_literal: true

require "application_system_test_case"

class ExercisesTest < ApplicationSystemTestCase
  test "creating a new exercise" do
    user = login

    create :exercise_type, user: user, name: "squat"
    workout = create :workout, :started, user: user

    visit workout_url(workout)

    click_on "New Exercise"

    assert_current_path workout_path(workout)

    choose "squat"
    click_on "Create"

    assert_current_path workout_path(workout)

    assert_text "squat"
  end

  test "editing an exercise" do
    user = login

    squat = create :exercise_type, user: user, name: "squat"
    create :exercise_type, user: user, name: "deadlift"
    workout = create :workout, :started, user: user
    exercise = create :exercise, workout: workout, exercise_type: squat

    visit workout_url(workout)

    within "##{dom_id(exercise)}" do
      click_on "Edit", match: :first
    end

    assert_current_path workout_path(workout)

    choose "deadlift"
    click_on "Update"

    assert_current_path workout_path(workout)

    assert_text "deadlift"
  end

  test "destroying an excercise" do
    user = login

    squat = create :exercise_type, user: user, name: "squat"
    workout = create :workout, user: user
    exercise = create :exercise, workout: workout, exercise_type: squat

    visit workout_url(workout)

    assert_text "squat"

    within "##{dom_id(exercise)}" do
      accept_confirm do
        click_on "Destroy", match: :first
      end
    end

    assert_current_path workout_path(workout)

    assert_no_text "squat"
  end
end
