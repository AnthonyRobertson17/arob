# frozen_string_literal: true

class DropExerciseCategories < ActiveRecord::Migration[7.0]
  def change
    drop_table(:exercise_categories) # rubocop:disable Rails/ReversibleMigration
  end
end
