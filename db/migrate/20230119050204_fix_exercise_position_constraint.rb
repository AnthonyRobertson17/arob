# frozen_string_literal: true

class FixExercisePositionConstraint < ActiveRecord::Migration[7.0]
  def up
    remove_index(:exercises, [:workout_id, :position])
  end

  def down
    add_index(:exercises, [:workout_id, :position], unique: true)
  end
end
