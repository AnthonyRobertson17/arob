# frozen_string_literal: true

require "application_system_test_case"

class WorkoutsTest < ApplicationSystemTestCase
  test "visiting the index" do
    user = login
    create :workout, user: user

    visit workouts_url
    assert_selector "h1", text: "Workouts"
  end

  test "creating workout" do
    user = login
    workout_category = create :workout_category, user: user

    visit workouts_url
    click_on "Create Workout"

    fill_in "Name", with: "Random workout name"
    select workout_category.name, from: "workout_workout_category_id"
    click_on "Create Workout"

    assert_text "Workout was successfully created."
  end

  test "can create workout from home page" do
    login
    click_on "Create Workout"

    assert_selector "h1", text: "New Workout"
  end

  test "cancel creating a workout" do
    login
    visit new_workout_url

    click_on "Cancel"
    assert_selector "h1", text: "Workouts"
  end

  test "editing Workouts" do
    user = login
    workout = create :workout, user: user

    visit workout_url(workout)
    click_on "Edit", match: :first

    fill_in "Name", with: workout.name
    click_on "Update Workout"

    assert_text "Workout was successfully updated."
  end

  test "cancel editing a workout" do
    user = login
    workout = create :workout, user: user

    visit edit_workout_url(workout)
    click_on "Cancel"
  end

  test "destroying Workout" do
    user = login
    workout = create :workout, user: user

    visit workout_url(workout)
    click_on "Destroy", match: :first

    assert_text "Workout was successfully destroyed."
  end

  test "starting Workout" do
    user = login
    workout = create :workout, user: user

    visit workout_url(workout)
    click_on "Start", match: :first

    assert_text "Workout was successfully started."
  end

  test "completing a Workout" do
    user = login
    workout = create :workout, :started, user: user

    visit workout_url(workout)
    assert_select "button", { text: "Start", count: 0 }
    click_on "Complete", match: :first

    assert_text "Workout was successfully completed."
  end
end
