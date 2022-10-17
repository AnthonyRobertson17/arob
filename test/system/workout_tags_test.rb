# frozen_string_literal: true

require "application_system_test_case"

class WorkoutTagsTest < ApplicationSystemTestCase
  test "visiting the index" do
    user = login
    create(:workout_tag, user:)

    click_on("Tags")
    click_on("Workout Tags")

    assert_current_path(workout_tags_path)
  end

  test "creating an workout_tag" do
    login
    visit(workout_tags_url)

    click_on("Create Workout Tag")

    # Ensure that the create form is inline on the workout index page
    assert_current_path(workout_tags_path)

    fill_in("Name", with: "New Tag name")
    click_on("Create")

    assert_current_path(workout_tags_path)
    assert_text("New Tag name")
  end

  test "cancel creating an workout_tag" do
    login
    visit(workout_tags_url)

    click_on("Create Workout Tag")

    # Ensure that the create form is inline on the workout index page
    assert_current_path(workout_tags_path)

    fill_in("Name", with: "New Tag name")

    click_on("Cancel")
    assert_current_path(workout_tags_path)
    assert_no_text("New Tag name")
  end

  test "editing an workout_tag" do
    user = login
    create(:workout_tag, user:)

    visit(workout_tags_url)
    find(".bi-pencil").click

    fill_in("Name", with: "Something new")
    click_on("Update")

    assert_text("Something new")
  end

  test "cancel editing an workout_tag" do
    user = login
    create(:workout_tag, user:)

    visit(workout_tags_url)
    find(".bi-pencil").click

    fill_in("Name", with: "Something new")
    click_on("Cancel")

    assert_no_text("Something new")
  end

  test "destroying an workout_tag" do
    user = login
    create(:workout_tag, user:, name: "Should be removed")

    visit(workout_tags_url)
    accept_confirm do
      find(".bi-trash3").click
    end

    assert_no_text("Should be removed")
  end
end
