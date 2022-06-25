# frozen_string_literal: true

require "application_system_test_case"

class ExerciseTypeTagsTest < ApplicationSystemTestCase
  test "visiting the index" do
    user = login
    create :exercise_type_tag, user: user

    click_on "Tags"
    click_on "Exercise Type Tags"

    assert_selector "h1", text: "Exercise Type Tags"
  end

  test "creating an exercise_type_tag" do
    login
    visit exercise_type_tags_url

    click_on "Create Exercise Type Tag"

    fill_in "Name", with: "Random Exercise Type Tag name"
    click_on "Create Exercise Type Tag"

    assert_text "Exercise Type Tag was successfully created."
  end

  test "cancel creating an exercise_type_tag" do
    login
    visit new_exercise_type_tag_url

    click_on "Cancel"
    assert_current_path exercise_type_tags_path
  end

  test "editing an exercise_type_tag" do
    user = login
    exercise_type_tag = create :exercise_type_tag, user: user

    visit exercise_type_tag_url(exercise_type_tag)
    click_on "Edit", match: :first

    fill_in "Name", with: "Something new"
    click_on "Update Exercise Type Tag"

    assert_text "Exercise Type Tag was successfully updated."
  end

  test "cancel editing an exercise_type_tag" do
    user = login
    exercise_type_tag = create :exercise_type_tag, user: user

    visit edit_exercise_type_tag_url(exercise_type_tag)
    click_on "Cancel"

    assert_current_path exercise_type_tag_path(exercise_type_tag)
  end

  test "destroying an exercise_type_tag" do
    user = login
    exercise_type_tag = create :exercise_type_tag, user: user

    visit exercise_type_tag_url(exercise_type_tag)
    click_on "Destroy", match: :first

    assert_text "Exercise Type Tag was successfully destroyed."
  end
end
