# frozen_string_literal: true

require "application_system_test_case"

class ExerciseTagsTest < ApplicationSystemTestCase
  test "visiting the index" do
    user = login
    create :exercise_tag, user: user

    click_on "Tags"
    click_on "Exercise Tags"

    assert_selector "h1", text: "Exercise Tags"
  end

  test "creating an exercise_tag" do
    login
    visit exercise_tags_url

    click_on "Create Exercise Tag"

    fill_in "Name", with: "Random Exercise Tag name"
    click_on "Create Exercise Tag"

    assert_text "Exercise Tag was successfully created."
  end

  test "cancel creating an exercise_tag" do
    login
    visit new_exercise_tag_url

    click_on "Cancel"
    assert_current_path exercise_tags_path
  end

  test "editing an exercise_tag" do
    user = login
    exercise_tag = create :exercise_tag, user: user

    visit exercise_tag_url(exercise_tag)
    click_on "Edit", match: :first

    fill_in "Name", with: "Something new"
    click_on "Update Exercise Tag"

    assert_text "Exercise Tag was successfully updated."
  end

  test "cancel editing an exercise_tag" do
    user = login
    exercise_tag = create :exercise_tag, user: user

    visit edit_exercise_tag_url(exercise_tag)
    click_on "Cancel"

    assert_current_path exercise_tag_path(exercise_tag)
  end

  test "destroying an exercise_tag" do
    user = login
    exercise_tag = create :exercise_tag, user: user

    visit exercise_tag_url(exercise_tag)
    click_on "Destroy", match: :first

    assert_text "Exercise Tag was successfully destroyed."
  end
end
