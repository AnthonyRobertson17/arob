# frozen_string_literal: true

require "application_system_test_case"

class ExerciseTypeTagsTest < ApplicationSystemTestCase
  test "visiting the index" do
    user = login
    create(:exercise_type_tag, user:)

    visit(fitness_url)

    click_on("Tags")
    click_on("Exercise Type Tags")

    assert_current_path(exercise_type_tags_path)
  end

  test "creating an exercise_type_tag" do
    login
    visit(exercise_type_tags_url)

    click_on("Create Exercise Type Tag")

    # Ensure that the create form is inline on the workout index page
    assert_current_path(exercise_type_tags_path)

    fill_in("Name", with: "New Tag name")
    click_on("Create")

    assert_current_path(exercise_type_tags_path)
    assert_text("New Tag name")
  end

  test "cancel creating an exercise_type_tag" do
    login
    visit(exercise_type_tags_url)

    click_on("Create Exercise Type Tag")

    # Ensure that the create form is inline on the workout index page
    assert_current_path(exercise_type_tags_path)

    fill_in("Name", with: "New Tag name")
    click_on("Cancel")

    assert_current_path(exercise_type_tags_path)
    assert_no_text("New Tag name")
  end

  test "editing an exercise_type_tag" do
    user = login
    create(:exercise_type_tag, user:)

    visit(exercise_type_tags_url)
    find(".bi-pencil").click

    fill_in("Name", with: "Something new")
    click_on("Update")

    assert_text("Something new")
  end

  test "cancel editing an exercise_type_tag" do
    user = login
    create(:exercise_type_tag, user:)

    visit(exercise_type_tags_url)
    find(".bi-pencil").click

    fill_in("Name", with: "Something new")
    click_on("Cancel")

    assert_no_text("Something new")
  end

  test "destroying an exercise_type_tag" do
    user = login
    create(:exercise_type_tag, user:, name: "Should be removed")

    visit(exercise_type_tags_url)
    accept_confirm do
      find(".bi-trash3").click
    end

    assert_no_text("Should be removed")
  end
end
