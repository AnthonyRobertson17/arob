# frozen_string_literal: true

class CreateExerciseSets < ActiveRecord::Migration[7.0]
  def change
    create_table(:exercise_sets) do |t|
      t.belongs_to(:exercise)
      t.integer(:repetitions)
      t.decimal(:weight)

      t.timestamps
    end
  end
end
