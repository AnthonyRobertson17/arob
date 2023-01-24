# frozen_string_literal: true

require "application_system_test_case"

class WorkoutsTest < ApplicationSystemTestCase
  test "visiting the index" do
    user = login
    create(:workout, user:)

    visit(workouts_url)

    assert_selector("h1", text: "Workouts")
  end

  test "creating workout" do
    user = login
    create(:workout_tag, user:, name: "test tag")

    visit(workouts_url)
    click_on("Create Workout")

    fill_in("Name", with: "Random workout name")
    check("test tag")
    click_on("Create")

    assert_text("Random workout name")
  end

  test "can create workout from home page" do
    login
    visit(fitness_url)
    click_on("Create Workout")

    assert_current_path(new_workout_path)
  end

  test "cancel creating a workout" do
    login
    visit(new_workout_url)

    click_on("Cancel")

    assert_selector("h1", text: "Workouts")
  end

  test "editing Workouts" do
    user = login
    workout = create(:workout, user:)
    create(:workout_tag, user:, name: "test tag")

    visit(workout_url(workout))
    find(".bi-pencil").click

    assert_current_path(workout_path(workout))

    fill_in("Name", with: "something else")
    check("test tag")
    click_on("Update")

    assert_text("something else")
  end

  test "cancel editing a workout" do
    user = login
    workout = create(:workout, user:)

    visit(edit_workout_url(workout))
    click_on("Cancel")
  end

  test "destroying Workout" do
    user = login
    workout = create(:workout, user:, name: "should be gone")

    visit(workout_url(workout))
    find(".bi-pencil").click
    accept_confirm do
      find(".bi-trash3").click
    end

    assert_no_text("should be gone")

    assert_current_path(workouts_path)
  end

  test "starting Workout" do
    user = login
    workout = create(:workout, user:)

    visit(workout_url(workout))
    click_on("Start", match: :first)

    assert_text("Started At")
  end

  test "completing a Workout" do
    user = login
    workout = create(:workout, :started, user:)

    visit(workout_url(workout))

    assert_select("button", { text: "Start", count: 0 })
    accept_confirm do
      click_on("Complete", match: :first)
    end

    assert_text("Completed At")
  end
end
