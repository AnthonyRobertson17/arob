# frozen_string_literal: true

require "test_helper"

class WorkoutTest < ActiveSupport::TestCase
  test "name is required" do
    workout = build(:workout, name: "")

    assert_predicate(workout, :invalid?)
  end

  test "can access tags through association" do
    user = create(:user)
    workout_tag = create(:workout_tag, user:, name: "test_tag")
    workout = create(:workout, user:, tags: [workout_tag])

    assert_equal("test_tag", workout.tags.first.name)
  end

  test "can access exercises through association" do
    workout = create(:workout)
    create(:exercise, workout:)
    create(:exercise, workout:)

    assert_equal(2, workout.exercises.count)
  end

  test "exercises are ordered by position" do
    workout = create(:workout)
    exercise1 = create(:exercise, workout:)
    exercise2 = create(:exercise, workout:)
    exercise3 = create(:exercise, workout:)

    exercise1.move_lower

    expected_ids = [exercise2.id, exercise1.id, exercise3.id]

    assert_equal(expected_ids, workout.exercises.map(&:id))
  end

  test "new workouts are not started or completed" do
    workout = build(:workout)

    assert_not(workout.started?)
    assert_not(workout.completed?)
  end

  test "for_user scope only returns workouts for the provided user" do
    user = create(:user)
    create(:workout)
    create(:workout, user:)

    assert_predicate(Workout.for_user(user), :one?)
  end

  test "completed scope only returns completed workouts" do
    create(:workout)
    create(:workout, :started)
    create(:workout, :completed)

    assert_predicate(Workout.completed, :one?)
  end

  test "completed? when false" do
    workout = build(:workout)

    assert_not(workout.completed?)
  end

  test "completed? when true" do
    workout = build(:workout, :completed)

    assert_predicate(workout, :completed?)
  end

  test "started? when false" do
    workout = build(:workout)

    assert_not(workout.started?)
  end

  test "started? when true" do
    workout = build(:workout, :started)

    assert_predicate(workout, :started?)
  end

  test "start! sets started_at if not already set" do
    workout = create(:workout)

    assert_not(workout.started?)

    workout.start!

    assert_predicate(workout.reload, :started?)
  end

  test "start! raises AlreadyStartedError if already started" do
    freeze_time do
      original_time = 2.days.ago
      workout = create(:workout, started_at: original_time)

      assert_raises(Workout::AlreadyStartedError) { workout.start! }

      assert_equal(original_time, workout.reload.started_at)
    end
  end

  test "in_progress? is true when started but not complete" do
    workout = build(:workout, :started)

    assert_predicate workout, :in_progress?
  end

  test "in_progress? is false when completed_at is set" do
    workout = build(:workout, :completed)

    assert_predicate(workout, :started?)
    assert_not(workout.in_progress?)
  end

  test "draft? when workout is draft" do
    workout = build(:workout)

    assert_predicate(workout, :draft?)
  end

  test "draft? when workout is started" do
    workout = build(:workout, :started)

    assert_not(workout.draft?)
  end

  test "draft? when workout is completed" do
    workout = build(:workout, :completed)

    assert_not(workout.draft?)
  end

  test "complete! sets completed_at" do
    workout = create(:workout, :started)

    freeze_time do
      workout.complete!

      assert_equal(Time.now.utc, workout.reload.completed_at)
    end
  end

  test "complete! raises NotStartedError if not started" do
    workout = create(:workout)

    assert_raises(Workout::NotStartedError) { workout.complete! }

    assert_nil(workout.reload.completed_at)
  end

  test "complete! raises AlreadyCompletedError if already completed" do
    freeze_time do
      original_time = 2.days.ago
      workout = create(:workout, completed_at: original_time)

      assert_raises(Workout::AlreadyCompletedError) { workout.complete! }

      assert_equal(original_time, workout.reload.completed_at)
    end
  end
end
