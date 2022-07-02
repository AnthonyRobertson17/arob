# frozen_string_literal: true

require "application_system_test_case"

class ExerciseTypeTest < ApplicationSystemTestCase
  test "visiting the index" do
    user = login
    create :exercise_type, user: user

    visit exercise_types_url
    assert_selector "h1", text: "Exercise Types"
  end

  test "creating exercise_type" do
    user = login
    create :exercise_type_tag, user: user, name: "test tag"

    visit exercise_types_url
    click_on "Create Exercise Type"

    fill_in "Name", with: "Random exercise_type name"
    check "test tag"
    click_on "Create Exercise Type"

    assert_text "Random exercise_type name"
  end

  test "cancel creating a exercise_type" do
    login
    visit new_exercise_type_url

    click_on "Cancel"
    assert_selector "h1", text: "Exercise Types"
  end

  test "editing Exercise Types" do
    user = login
    exercise_type = create :exercise_type, user: user
    create :exercise_type_tag, user: user, name: "test tag"

    visit exercise_type_url(exercise_type)
    click_on "Edit", match: :first

    fill_in "Name", with: "something else"
    check "test tag"
    click_on "Update Exercise Type"

    assert_text "something else"
  end

  test "cancel editing a exercise_type" do
    user = login
    exercise_type = create :exercise_type, user: user

    visit edit_exercise_type_url(exercise_type)
    click_on "Cancel"
  end

  test "destroying Exercise Type" do
    user = login
    exercise_type = create :exercise_type, user: user, name: "should be gone"

    visit exercise_type_url(exercise_type)
    click_on "Destroy", match: :first

    assert_no_text "should be gone"
  end
end
