# frozen_string_literal: true

class DropWorkoutCategoryIdFromWorkouts < ActiveRecord::Migration[7.0]
  def change
    remove_column(:workouts, :workout_category_id) # rubocop:disable Rails/ReversibleMigration
  end
end
