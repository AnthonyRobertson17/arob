# frozen_string_literal: true

class LinkWorkoutCategoryToWorkout < ActiveRecord::Migration[7.0]
  def change
    add_reference(:workouts, :workout_category, foreign_key: true)
  end
end
