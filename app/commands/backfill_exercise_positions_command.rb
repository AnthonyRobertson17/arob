# frozen_string_literal: true

class BackfillExercisePositionsCommand < BaseCommand
  def execute
    User.all.each { |user| update_user(user) }
  end

  private

  def update_user(user)
    user.workouts.each { |workout| update_workout(workout) }
  end

  def update_workout(workout)
    workout.exercises.order(id: :desc).each_with_index do |exercise, i|
      exercise.update!(position: i)
    end
  end
end
