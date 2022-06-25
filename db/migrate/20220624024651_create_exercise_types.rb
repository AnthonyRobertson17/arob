class CreateExerciseTypes < ActiveRecord::Migration[7.0]
  def change
    create_table :exercise_types do |t|
      t.string :name, null: false
      t.belongs_to :user

      t.timestamps
    end
  end
end
