# frozen_string_literal: true

require "application_system_test_case"

class ExerciseTypesTest < ApplicationSystemTestCase
  test "visiting the index" do
    user = login
    create(:exercise_type, user:)

    visit(exercise_types_url)

    assert_selector("h1", text: "Exercise Types")
  end

  test "creating exercise_type" do
    user = login
    create(:exercise_type_tag, user:, name: "test tag")

    visit(exercise_types_url)
    click_on("Create Exercise Type")

    assert_current_path(exercise_types_path)

    fill_in("Name", with: "Random exercise_type name")
    check("test tag")
    click_on("Create")

    assert_current_path(exercise_types_path)

    assert_text("Random exercise_type name")
  end

  test "cancel creating a exercise_type" do
    user = login
    create(:exercise_type_tag, user:, name: "test tag")

    visit(exercise_types_url)
    click_on("Create Exercise Type")

    assert_current_path(exercise_types_path)

    fill_in("Name", with: "Random exercise_type name")
    check("test tag")
    click_on("Cancel")

    assert_current_path(exercise_types_path)

    assert_no_text("Random exercise_type name")
  end

  test "editing Exercise Types" do
    user = login
    create(:exercise_type, user:)
    create(:exercise_type_tag, user:, name: "test tag")

    visit(exercise_types_url)
    find(".bi-pencil").click

    assert_current_path(exercise_types_path)

    fill_in("Name", with: "something else")
    check("test tag")
    click_on("Update")

    assert_current_path(exercise_types_path)

    assert_text("something else")
  end

  test "cancel editing a exercise_type" do
    user = login
    create(:exercise_type, user:)
    create(:exercise_type_tag, user:, name: "test tag")

    visit(exercise_types_url)
    find(".bi-pencil").click

    assert_current_path(exercise_types_path)

    fill_in("Name", with: "something else")
    check("test tag")
    click_on("Cancel")

    assert_current_path(exercise_types_path)

    assert_no_text("something else")
  end

  test "destroying Exercise Type" do
    user = login
    create(:exercise_type, user:, name: "should be gone")

    visit(exercise_types_url)
    accept_confirm do
      find(".bi-trash3").click
    end

    assert_current_path(exercise_types_path)

    assert_no_text("should be gone")
  end
end
