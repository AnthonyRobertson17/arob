# frozen_string_literal: true

require "application_system_test_case"

class WorkoutTagsTest < ApplicationSystemTestCase
  test "visiting the index" do
    user = login
    create :workout_tag, user: user

    click_on "Tags"
    click_on "Workout Tags"

    assert_selector "h1", text: "Workout Tags"
  end

  test "creating an workout_tag" do
    login
    visit workout_tags_url

    click_on "Create Workout Tag"

    fill_in "Name", with: "Random Workout Tag name"
    click_on "Create Workout Tag"

    assert_text "Workout Tag was successfully created."
  end

  test "cancel creating an workout_tag" do
    login
    visit new_workout_tag_url

    click_on "Cancel"
    assert_current_path workout_tags_path
  end

  test "editing an workout_tag" do
    user = login
    workout_tag = create :workout_tag, user: user

    visit workout_tag_url(workout_tag)
    click_on "Edit", match: :first

    fill_in "Name", with: "Something new"
    click_on "Update Workout Tag"

    assert_text "Workout Tag was successfully updated."
  end

  test "cancel editing an workout_tag" do
    user = login
    workout_tag = create :workout_tag, user: user

    visit edit_workout_tag_url(workout_tag)
    click_on "Cancel"

    assert_current_path workout_tag_path(workout_tag)
  end

  test "destroying an workout_tag" do
    user = login
    workout_tag = create :workout_tag, user: user

    visit workout_tag_url(workout_tag)
    click_on "Destroy", match: :first

    assert_text "Workout Tag was successfully destroyed."
  end
end
