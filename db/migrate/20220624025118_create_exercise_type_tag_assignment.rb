# frozen_string_literal: true

class CreateExerciseTypeTagAssignment < ActiveRecord::Migration[7.0]
  def change
    create_table :exercise_type_tag_assignments do |t|
      t.references :tag, null: false, foreign_key: true
      t.references :exercise_type, null: false, foreign_key: true
      t.timestamps
    end
  end
end
