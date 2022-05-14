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

  test "start! sets started_at if not already set" do
    workout = create :workout
    assert_not workout.started?

    workout.start!
    assert_predicate workout, :started?
  end

  test "start! raises AlreadyStartedError if already started" do
    start_time = 2.days.ago
    workout = create :workout, started_at: start_time

    assert_raises(Workout::AlreadyStartedError) { workout.start! }

    assert_equal start_time, workout.started_at
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

  test "completed is true when completed_at is set" do
    workout = build :workout, :completed

    assert_predicate workout, :completed?
  end
end
