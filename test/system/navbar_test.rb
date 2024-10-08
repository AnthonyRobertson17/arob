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
    visit(fitness_url)
    click_on("Workouts")

    assert_current_path(workouts_path)
  end

  test "navigating to the equipment page" do
    login
    visit(fitness_url)
    click_on("Equipment")

    assert_current_path(equipment_index_path)
  end

  test "navigating to the gyms page" do
    login
    visit(fitness_url)
    click_on("Gyms")

    assert_current_path(gyms_path)
  end

  test "navigating to the exercise types page" do
    login
    visit(fitness_url)
    click_on("Exercise Types")

    assert_current_path(exercise_types_path)
  end

  test "navigating to the workout_tags page" do
    login
    visit(fitness_url)
    click_on("Tags")
    click_on("Workout Tags")

    assert_current_path(workout_tags_path)
  end

  test "navigating to the wishlists page" do
    login
    visit(new_wishlist_url)
    click_on("Wishlists")

    assert_current_path(wishlists_path)
  end

  test "logging out" do
    login
    visit(root_url)

    click_on("Logout")

    assert_current_path(new_user_session_path)
  end
end
