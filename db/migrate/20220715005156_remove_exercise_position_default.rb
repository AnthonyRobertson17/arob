# frozen_string_literal: true

class RemoveExercisePositionDefault < ActiveRecord::Migration[7.0]
  def change
    change_column_default(:exercises, :position, from: 0, to: nil)
  end
end
