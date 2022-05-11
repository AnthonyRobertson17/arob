# frozen_string_literal:true

require "application_system_test_case"

class NavbarTest < ApplicationSystemTestCase
  test "clicking the site name brings user to root" do
    visit workouts_url
    click_on "Lift-O-Tracker"

    assert_current_path root_path
  end

  test "navigating to the workouts page" do
    visit workout_categories_url
    click_on "Workouts"

    assert_current_path workouts_path
  end

  test "navigating to the workout categories page" do
    visit workouts_url
    click_on "Workout Categories"

    assert_current_path workout_categories_path
  end
end
