# frozen_string_literal: true

require "application_system_test_case"

class ExerciseSetsTest < ApplicationSystemTestCase
  test "creating a new exercise_set" do
    user = login

    create(:exercise_type, user:, name: "squat")
    workout = create(:workout, :started, user:)
    create(:exercise, workout:)

    visit workout_url(workout)

    click_on "Add Set"

    assert_current_path workout_path(workout)

    fill_in "Weight", with: 25
    fill_in "Reps", with: 10

    click_on "Create"

    assert_current_path workout_path(workout)

    assert_text "Weight: 25.0 - Reps: 10"
  end

  test "editing an exercise_set" do
    user = login

    exercise_type = create(:exercise_type, user:, name: "squat")
    workout = create(:workout, :started, user:)
    exercise = create(:exercise, workout:, exercise_type:)
    exercise_set = create(:exercise_set, exercise:, weight: 1, repetitions: 1)

    visit workout_url(workout)

    assert_text "Weight: 1.0 - Reps: 1"

    within "##{dom_id(exercise_set)}" do
      click_on "Edit", match: :first

      assert_current_path workout_path(workout)

      fill_in "Weight", with: 25
      fill_in "Reps", with: 10

      assert_current_path workout_path(workout)

      click_on "Update"
    end

    assert_text "Weight: 25.0 - Reps: 10"
  end

  test "destroying an excercise_set" do
    user = login

    exercise_type = create(:exercise_type, user:, name: "squat")
    workout = create(:workout, :started, user:)
    exercise = create(:exercise, workout:, exercise_type:)
    exercise_set = create(:exercise_set, exercise:, weight: 1, repetitions: 1)

    visit workout_url(workout)

    assert_text "Weight: 1.0 - Reps: 1"

    within "##{dom_id(exercise_set)}" do
      accept_confirm do
        click_on "Destroy", match: :first
      end
    end

    assert_current_path workout_path(workout)

    assert_no_text "Weight: 1.0 - Reps: 1"
  end
end
