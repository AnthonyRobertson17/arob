# frozen_string_literal: true

class AddPositionToExercises < ActiveRecord::Migration[7.0]
  def change
    add_column(:exercises, :position, :integer, null: false, default: 0)
  end
end
