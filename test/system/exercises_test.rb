# frozen_string_literal: true

require "application_system_test_case"

class ExercisesTest < ApplicationSystemTestCase
  test "creating a new exercise" do
    user = login

    create :exercise_type, user: user, name: "squat"
    workout = create(:workout, :started, user:)

    visit workout_url(workout)

    click_on "New Exercise"

    assert_current_path workout_path(workout)

    choose "squat"
    fill_in "Note", with: "This is a custom note"
    click_on "Create"

    assert_current_path workout_path(workout)

    assert_text "squat"
    assert_text "This is a custom note"
  end

  test "editing an exercise" do
    user = login

    squat = create(:exercise_type, user:, name: "squat")
    create :exercise_type, user: user, name: "deadlift"
    workout = create(:workout, :started, user:)
    exercise = create(:exercise, workout:, exercise_type: squat)

    visit workout_url(workout)

    within "##{dom_id(exercise)}" do
      click_on "✏️", match: :first
    end

    assert_current_path workout_path(workout)

    choose "deadlift"
    fill_in "Note", with: "This is a completely new note"
    click_on "Update"

    assert_current_path workout_path(workout)

    assert_text "This is a completely new note"
    assert_text "deadlift"
  end

  test "destroying an excercise" do
    user = login

    squat = create(:exercise_type, user:, name: "squat")
    workout = create(:workout, user:)
    exercise = create(:exercise, workout:, exercise_type: squat)

    visit workout_url(workout)

    assert_text "squat"

    within "##{dom_id(exercise)}" do
      accept_confirm do
        click_on "💣", match: :first
      end
    end

    assert_current_path workout_path(workout)

    assert_no_text "squat"
  end
end
