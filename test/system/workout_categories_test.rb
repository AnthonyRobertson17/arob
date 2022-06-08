# frozen_string_literal:true

require "application_system_test_case"

class WorkoutCategoriesTest < ApplicationSystemTestCase
  test "visiting the index" do
    user = login
    create :workout_category, user: user

    visit workout_categories_url
    assert_selector "h1", text: "Workout categories"
  end

  test "should create workout category" do
    user = login
    create :workout_category, user: user

    visit workout_categories_url
    click_on "New workout category"

    fill_in "Name", with: "Random Name"
    click_on "Create Workout Category"

    assert_text "Workout Category was successfully created"
    click_on "Back"
  end

  test "should update Workout category" do
    user = login
    workout_category = create :workout_category, user: user

    visit workout_category_url(workout_category)
    click_on "Edit this workout category", match: :first

    fill_in "Name", with: "New workout name"
    click_on "Update Workout Category"

    assert_text "Workout Category was successfully updated"
    click_on "Back"
  end

  test "should destroy Workout category" do
    user = login
    workout_category = create :workout_category, user: user

    visit workout_category_url(workout_category)
    click_on "Destroy this workout category", match: :first

    assert_text "Workout Category was successfully destroyed"
  end
end
