# frozen_string_literal: true

class CreateExerciseCategories < ActiveRecord::Migration[7.0]
  def change
    create_table(:exercise_categories) do |t|
      t.string(:name)
      t.belongs_to(:user)

      t.timestamps
    end
  end
end
