# frozen_string_literal: true

# rubocop:disable Metrics/AbcSize, Metrics/MethodLength
class CreateTestDataCommand < BaseCommand
  def execute
    users
    workout_tags
    exercise_tags
    workouts
  end

  private

  def users
    @users ||= User.create!([
      { email: "dev@test.test", password: "password12345" },
      { email: "dev2@test.test", password: "password12345" },
    ])
  end

  def workout_tags
    @workout_tags ||= WorkoutTag.create!([
      { name: "Legs", user: users[0] },
      { name: "Chest", user: users[0] },
      { name: "Chest for user 2", user: users[1] },
    ])
  end

  def exercise_tags
    @exercise_tags ||= ExerciseTag.create!([
      { name: "Biceps", user: users[0] },
      { name: "Triceps", user: users[0] },
      { name: "Chest", user: users[1] },
      { name: "Legs", user: users[1] },
    ])
  end

  def workouts
    @workouts ||= Workout.create!([
      {
        name: "Leg Day",
        user: users[0],
      },
      {
        name: "Chest Day",
        started_at: 2.days.ago,
        completed_at: 2.days.ago + 1.hour,
        user: users[0],
      },
      {
        name: "Silly Day",
        started_at: 2.days.ago,
        completed_at: 2.days.ago + 1.hour,
        user: users[1],
      },
    ])
  end
end
# rubocop:enable Metrics/AbcSize, Metrics/MethodLength
