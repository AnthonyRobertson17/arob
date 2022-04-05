# frozen_string_literal: true

require "test_helper"

class WorkoutTest < ActiveSupport::TestCase
  test "new workouts are not started or completed" do
    workout = build :workout

    assert_not workout.started?
    assert_not workout.completed?
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
