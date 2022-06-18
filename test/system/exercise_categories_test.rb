# frozen_string_literal: true

require "application_system_test_case"

class ExerciseCategoriesTest < ApplicationSystemTestCase
  test "visiting the index" do
    user = login
    create :exercise_category, user: user

    visit exercise_categories_url
    assert_selector "h1", text: "Exercise Categories"
  end

  test "create Exercise category" do
    user = login
    create :exercise_category, user: user

    visit exercise_categories_url
    click_on "Create Exercise Category"

    fill_in "Name", with: "Random Name"
    click_on "Create Exercise Category"

    assert_text "Exercise Category was successfully created"
  end

  test "update Exercise category" do
    user = login
    exercise_category = create :exercise_category, user: user

    visit exercise_category_url(exercise_category)
    click_on "Edit", match: :first

    fill_in "Name", with: "New workout name"
    click_on "Update Exercise Category"

    assert_text "Exercise Category was successfully updated"
  end

  test "destroy Exercise category" do
    user = login
    exercise_category = create :exercise_category, user: user

    visit exercise_category_url(exercise_category)
    click_on "Destroy", match: :first

    assert_text "Exercise Category was successfully destroyed"
  end
end
