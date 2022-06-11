# frozen_string_literal: true

require "test_helper"

class WorkoutTest < ActiveSupport::TestCase
  test "name is required" do
    workout = build :workout, name: ""
    assert_predicate workout, :invalid?
  end

  test "workout category must share user with workout" do
    workout_category = build :workout_category
    workout = build :workout, workout_category: workout_category

    assert_predicate workout, :invalid?
    assert_equal "Workout Category not found", workout.errors.first.full_message
  end

  test "workout must have a workout_category" do
    workout = build :workout, workout_category_id: nil

    assert_not workout.valid?
    assert_equal 1, workout.errors.to_a.length
    assert_equal "Workout Category must exist", workout.errors.first.full_message
  end

  test "new workouts are not started or completed" do
    workout = build :workout

    assert_not workout.started?
    assert_not workout.completed?
  end

  test "for_user scope only returns workouts for the provided user" do
    user = create :user
    create :workout
    create :workout, user: user

    assert_predicate Workout.for_user(user), :one?
  end

  test "completed scope only returns completed workouts" do
    create :workout
    create :workout, :started
    create :workout, :completed

    assert_predicate Workout.completed, :one?
  end

  test "completed? when false" do
    workout = build :workout
    assert_not workout.completed?
  end

  test "completed? when true" do
    workout = build :workout, :completed
    assert_predicate workout, :completed?
  end

  test "started? when false" do
    workout = build :workout
    assert_not workout.started?
  end

  test "started? when true" do
    workout = build :workout, :started
    assert_predicate workout, :started?
  end

  test "start! sets started_at if not already set" do
    workout = create :workout
    assert_not workout.started?

    workout.start!
    assert_predicate workout, :started?
  end

  test "start! raises AlreadyStartedError if already started" do
    freeze_time do
      original_time = 2.days.ago
      workout = create :workout, started_at: original_time

      assert_raises(Workout::AlreadyStartedError) { workout.start! }

      assert_equal original_time, workout.reload.started_at
    end
  end

  test "in_progress? is true when started but not complete" do
    workout = build :workout, :started

    assert_predicate workout, :in_progress?
  end

  test "in_progress? is false when completed_at is set" do
    workout = build :workout, :completed

    assert_predicate workout, :started?
    assert_not workout.in_progress?
  end

  test "draft? when workout is draft" do
    workout = build :workout
    assert_predicate workout, :draft?
  end

  test "draft? when workout is started" do
    workout = build :workout, :started
    assert_not workout.draft?
  end

  test "draft? when workout is completed" do
    workout = build :workout, :completed
    assert_not workout.draft?
  end

  test "complete! sets completed_at" do
    workout = create :workout, :started

    freeze_time do
      workout.complete!

      assert_equal Time.now.utc, workout.completed_at
    end
  end

  test "complete! raises NotStartedError if not started" do
    workout = create :workout

    assert_raises(Workout::NotStartedError) { workout.complete! }

    assert_nil workout.reload.completed_at
  end

  test "complete! raises AlreadyCompletedError if already completed" do
    freeze_time do
      original_time = 2.days.ago
      workout = create :workout, completed_at: original_time

      assert_raises(Workout::AlreadyCompletedError) { workout.complete! }

      assert_equal original_time, workout.reload.completed_at
    end
  end
end
