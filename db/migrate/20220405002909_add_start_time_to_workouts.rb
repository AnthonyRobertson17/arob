# frozen_string_literal: true

class AddStartTimeToWorkouts < ActiveRecord::Migration[7.0]
  def change
    add_column :workouts, :started_at, :datetime
  end
end
