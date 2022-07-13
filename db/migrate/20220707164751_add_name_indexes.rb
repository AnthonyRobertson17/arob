# frozen_string_literal: true

class AddNameIndexes < ActiveRecord::Migration[7.0]
  def change
    add_index(:exercise_types, :name)
    add_index(:tags, :name)
    add_index(:workouts, :name)
  end
end
