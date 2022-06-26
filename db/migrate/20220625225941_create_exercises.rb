class CreateExercises < ActiveRecord::Migration[7.0]
  def change
    create_table :exercises do |t|
      t.belongs_to :workout
      t.belongs_to :exercise_type

      t.timestamps
    end
  end
end
