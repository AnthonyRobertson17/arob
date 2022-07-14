# frozen_string_literal: true

require "test_helper"

class BackfillExercisePositionsCommandTest < ActiveSupport::TestCase
  setup do
    create_users
  end

  def create_users
    users = Array.new(5).map { create(:user) }
    users.each { |user| create_workouts(user) }
  end

  def create_workouts(user)
    workouts = Array.new(5).map { create(:workout, user:) }
    workouts.each { |workout| create_exercises(workout) }
  end

  def create_exercises(workout)
    5.times { create(:exercise, workout:, position: 0) }
  end

  test "without doing anything, all exercises have position 0" do
    Exercise.all.each do |exercise|
      assert_equal(0, exercise.position)
    end
  end

  test "after running backfill, positions are correctly set" do
    BackfillExercisePositionsCommand.execute

    User.all.each do |user|
      user.workouts.all.each do |workout|
        positions = workout.exercises.order(id: :desc).map(&:position)
        assert_equal((0..4).to_a, positions)
      end
    end
  end
end
