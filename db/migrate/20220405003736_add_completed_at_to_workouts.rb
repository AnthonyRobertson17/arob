# frozen_string_literal: true

class AddCompletedAtToWorkouts < ActiveRecord::Migration[7.0]
  def change
    add_column :workouts, :completed_at, :datetime
  end
end
