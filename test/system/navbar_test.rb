# frozen_string_literal:true

require "application_system_test_case"

class NavbarTest < ApplicationSystemTestCase
  test "clicking the site name brings user to root" do
    login
    visit workouts_url
    click_on "Lift-O-Tracker"

    assert_current_path root_path
  end

  test "navigating to the workouts page" do
    login
    click_on "Workouts"

    assert_current_path workouts_path
  end

  test "navigating to the all tags page" do
    login
    click_on "Tags"
    click_on "All Tags"

    assert_current_path tags_path
  end

  test "navigating to the workout_tags page" do
    login
    click_on "Tags"
    click_on "Workout Tags"

    assert_current_path workout_tags_path
  end

  test "navigating to the exercise_tags page" do
    login
    click_on "Tags"
    click_on "Exercise Tags"

    assert_current_path exercise_tags_path
  end
end
