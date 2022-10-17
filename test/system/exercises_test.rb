# frozen_string_literal: true

require "application_system_test_case"

class ExercisesTest < ApplicationSystemTestCase
  def create_exercises(user:, workout:, count:)
    exercises = []
    count.times do
      exercise_type = create(:exercise_type, user:)
      exercises << create(:exercise, workout:, exercise_type:)
    end
    exercises
  end

  def assert_page_order(first, second)
    assert(page.body.index(first) < page.body.index(second))
  end

  test "creating a new exercise" do
    user = login

    create(:exercise_type, user:, name: "watwatwat")
    workout = create(:workout, user:)

    visit(workout_url(workout))

    click_on("New Exercise")

    assert_current_path(workout_path(workout))

    choose("watwatwat")
    fill_in("Note", with: "This is a custom note")
    click_on("Create")

    assert_current_path(workout_path(workout))

    assert_text("watwatwat")
    assert_text("This is a custom note")
  end

  test "editing an exercise" do
    user = login

    squat = create(:exercise_type, user:, name: "squat")
    create :exercise_type, user:, name: "deadlift"
    workout = create(:workout, :started, user:)
    exercise = create(:exercise, workout:, exercise_type: squat)

    visit(workout_url(workout))

    within("##{dom_id(exercise)}") do
      find(".bi-pencil").click
    end

    assert_current_path(workout_path(workout))

    choose("deadlift")
    fill_in("Note", with: "This is a completely new note")
    click_on("Update")

    assert_current_path(workout_path(workout))

    assert_text("This is a completely new note")
    assert_text("deadlift")
  end

  test "destroying the first excercise" do
    user = login
    workout = create(:workout, user:)
    exercises = create_exercises(user:, workout:, count: 3)
    first = exercises.first

    visit(workout_url(workout))

    within("##{dom_id(first)}") do
      find(".bi-pencil").click
      accept_confirm do
        find(".bi-trash3").click
      end
    end

    assert_current_path(workout_path(workout))

    assert_no_text(first.name)
  end

  test "destroying the last excercise" do
    user = login
    workout = create(:workout, user:)
    exercises = create_exercises(user:, workout:, count: 3)
    last = exercises.last

    visit(workout_url(workout))

    within("##{dom_id(last)}") do
      find(".bi-pencil").click
      accept_confirm do
        find(".bi-trash3").click
      end
    end

    assert_current_path(workout_path(workout))

    assert_no_text(last.name)
  end

  test "move exercise down" do
    user = login
    workout = create(:workout, user:)
    exercises = create_exercises(user:, workout:, count: 3)

    first = exercises.first
    second = exercises.at(1)

    visit(workout_url(workout))

    assert_page_order(first.name, second.name)

    within("##{dom_id(first)}") do
      find(".bi-arrow-down").click
    end

    assert_page_order(second.name, first.name)
  end

  test "move exercise up" do
    user = login
    workout = create(:workout, user:)
    exercises = create_exercises(user:, workout:, count: 3)

    last = exercises.last
    second = exercises.at(1)

    visit(workout_url(workout))

    assert_page_order(second.name, last.name)

    within("##{dom_id(last)}") do
      find(".bi-arrow-up").click
    end

    assert_page_order(last.name, second.name)
  end
end
