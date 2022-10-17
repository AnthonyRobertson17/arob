# frozen_string_literal: true

require "application_system_test_case"

class ExerciseSetsTest < ApplicationSystemTestCase
  test "creating a new exercise_set" do
    user = login

    create(:exercise_type, user:, name: "squat")
    workout = create(:workout, :started, user:)
    create(:exercise, workout:)

    visit(workout_url(workout))

    click_on("Add Set")

    assert_current_path(workout_path(workout))

    fill_in(id: "exercise_set_weight", with: 478)
    fill_in(id: "exercise_set_repetitions", with: 732)

    click_on("Save")

    assert_current_path(workout_path(workout))

    assert_text("478")
    assert_text("732")
  end

  test "editing an exercise_set" do
    user = login

    exercise_type = create(:exercise_type, user:, name: "squat")
    workout = create(:workout, :started, user:)
    exercise = create(:exercise, workout:, exercise_type:)
    exercise_set = create(:exercise_set, exercise:, weight: 468, repetitions: 42)

    visit(workout_url(workout))

    assert_text("468")
    assert_text("42")

    within("##{dom_id(exercise_set)}") do
      find(".bi-pencil").click

      assert_current_path(workout_path(workout))

      fill_in(id: "exercise_set_weight", with: 642)
      fill_in(id: "exercise_set_repetitions", with: 75)

      assert_current_path(workout_path(workout))

      click_on("Save")
    end

    assert_text("642")
    assert_text("75")
  end

  test "destroying an excercise_set" do
    user = login

    exercise_type = create(:exercise_type, user:, name: "squat")
    workout = create(:workout, :started, user:)
    exercise = create(:exercise, workout:, exercise_type:)
    exercise_set = create(:exercise_set, exercise:, weight: 69_420, repetitions: 1337)

    visit(workout_url(workout))

    assert_text("69420")
    assert_text("1337")

    within("##{dom_id(exercise_set)}") do
      find(".bi-pencil").click
      accept_confirm do
        find(".bi-trash3").click
      end
    end

    assert_current_path(workout_path(workout))

    assert_no_text("69420")
  end
end
