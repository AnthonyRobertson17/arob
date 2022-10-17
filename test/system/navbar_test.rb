# frozen_string_literal:true

require "application_system_test_case"

class NavbarTest < ApplicationSystemTestCase
  test "clicking the site name brings user to root" do
    login
    visit(workouts_url)
    click_on("arob")

    assert_current_path(root_path)
  end

  test "navigating to the workouts page" do
    login
    visit(gym_url)
    click_on("Workouts")

    assert_current_path(workouts_path)
  end

  test "navigating to the exercise types page" do
    login
    visit(gym_url)
    click_on("Exercise Types")

    assert_current_path(exercise_types_path)
  end

  test "navigating to the workout_tags page" do
    login
    visit(gym_url)
    click_on("Tags")
    click_on("Workout Tags")

    assert_current_path(workout_tags_path)
  end
end
