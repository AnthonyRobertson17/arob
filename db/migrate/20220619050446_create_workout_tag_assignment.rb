# frozen_string_literal: true

class CreateWorkoutTagAssignment < ActiveRecord::Migration[7.0]
  def change
    create_table(:workout_tag_assignments) do |t|
      t.references(:tag, null: false, foreign_key: true)
      t.references(:workout, null: false, foreign_key: true)
      t.timestamps
    end
  end
end
