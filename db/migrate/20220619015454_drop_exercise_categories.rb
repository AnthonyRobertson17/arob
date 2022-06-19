class DropExerciseCategories < ActiveRecord::Migration[7.0]
  def change
    drop_table :exercise_categories
  end
end
