# frozen_string_literal: true

class CreateWorkouts < ActiveRecord::Migration[7.0]
  def change
    create_table :workouts do |t|
      t.string :name, null: false

      t.timestamps
    end
  end
end
