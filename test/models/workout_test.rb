# frozen_string_literal: true

require "test_helper"

class WorkoutTest < ActiveSupport::TestCase
  test "name is required" do
    workout = build :workout, name: ""
    assert_predicate workout, :invalid?
  end

  test "new workouts are not started or completed" do
    workout = build :workout

    assert_not workout.started?
    assert_not workout.completed?
  end

  test "completed scope only returns completed workouts" do
    create :workout
    create :workout, :started
    create :workout, :completed

    assert_predicate Workout.completed, :one?
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

  test "started? is true when started_at is set" do
    workout = build :workout, :started

    assert_predicate workout, :started?
  end

  test "active? is true when started but not complete" do
    workout = build :workout, :started

    assert_predicate workout, :active?
  end

  test "active? is false when completed_at is set" do
    workout = build :workout, :completed

    assert_predicate workout, :started?
    assert_not workout.active?
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

  test "completed? is true when completed_at is set" do
    workout = build :workout, :completed

    assert_predicate workout, :completed?
  end
end
