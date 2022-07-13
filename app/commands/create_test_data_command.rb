# frozen_string_literal: true

# rubocop:disable Metrics/AbcSize, Metrics/MethodLength, Metrics/ClassLength
class CreateTestDataCommand < BaseCommand
  def execute
    users
    workout_tags
    exercise_type_tags
    workouts
    exercise_types
    exercises
    exercise_sets
  end

  private

  def seed(klass, find_by:, update: nil)
    instance = klass.find_or_initialize_by(find_by)
    instance.update(update) if update
    instance.save!
    instance
  end

  def users
    @users ||= [
      seed(
        User,
        find_by: { email: "dev@test.test" },
        update: { password: "password12345" },
      ),
      seed(
        User,
        find_by: { email: "dev2@test.test" },
        update: { password: "password12345" },
      ),
    ]
  end

  def workout_tags
    @workout_tags ||= [
      seed(
        WorkoutTag,
        find_by: { name: "Legs", user: users[0] },
      ),
      seed(
        WorkoutTag,
        find_by: { name: "Chest", user: users[0] },
      ),
      seed(
        WorkoutTag,
        find_by: { name: "Chest for user 2", user: users[1] },
      ),
    ]
  end

  def exercise_type_tags
    @exercise_type_tags ||= [
      seed(
        ExerciseTypeTag,
        find_by: { name: "Biceps", user: users[0] },
      ),
      seed(
        ExerciseTypeTag,
        find_by: { name: "Triceps", user: users[0] },
      ),
      seed(
        ExerciseTypeTag,
        find_by: { name: "Chest", user: users[1] },
      ),
      seed(
        ExerciseTypeTag,
        find_by: { name: "Legs", user: users[1] },
      ),
    ]
  end

  def exercise_types
    @exercise_types ||= [
      seed(
        ExerciseType,
        find_by: { name: "Bicep Curl", user: users[0] },
      ),
      seed(
        ExerciseType,
        find_by: { name: "Tricep Extension", user: users[0] },
      ),
      seed(
        ExerciseType,
        find_by: { name: "Bench Press", user: users[1] },
      ),
      seed(
        ExerciseType,
        find_by: { name: "Shoulder Press", user: users[1] },
      ),
    ]
  end

  def workouts
    @workouts ||= [
      seed(
        Workout,
        find_by: { name: "Let's GOOOO", user: users[0] },
        update: { started_at: 2.days.ago },
      ),
      seed(
        Workout,
        find_by: { name: "Leg Day", user: users[0] },
      ),
      seed(
        Workout,
        find_by: { name: "Chest Day", user: users[0] },
        update: { started_at: 2.days.ago, completed_at: 2.days.ago + 1.hour },
      ),
      seed(
        Workout,
        find_by: { name: "Silly Day", user: users[1] },
        update: { started_at: 2.days.ago, completed_at: 2.days.ago + 1.hour },
      ),
    ]
  end

  def exercises
    @exercises ||= [
      seed(
        Exercise,
        find_by: { exercise_type: exercise_types[0], workout: workouts[0] },
        update: { note: "Used straps, and failed the last rep" },
      ),
      seed(
        Exercise,
        find_by: { exercise_type: exercise_types[1], workout: workouts[0] },
        update: { note: "Used straps, and failed the last rep" },
      ),
    ]
  end

  def exercise_sets
    return @exercise_sets if @exercise_sets

    @exercise_sets = []
    exercises.each do |exercise|
      @exercise_sets += [
        seed(
          ExerciseSet,
          find_by: { exercise:, weight: 12.5, repetitions: 15 },
        ),
        seed(
          ExerciseSet,
          find_by: { exercise:, weight: 25, repetitions: 10 },
        ),
        seed(
          ExerciseSet,
          find_by: { exercise:, weight: 35, repetitions: 10 },
        ),
        seed(
          ExerciseSet,
          find_by: { exercise:, weight: 45, repetitions: 8 },
        ),
      ]
    end

    @exercise_sets
  end
end
# rubocop:enable Metrics/AbcSize, Metrics/MethodLength, Metrics/ClassLength
