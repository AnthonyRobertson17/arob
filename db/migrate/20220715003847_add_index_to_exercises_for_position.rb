# frozen_string_literal: true

class AddIndexToExercisesForPosition < ActiveRecord::Migration[7.0]
  def change
    add_index(:exercises, [:workout_id, :position], unique: true)
  end
end
