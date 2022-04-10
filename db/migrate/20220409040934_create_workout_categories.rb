# frozen_string_literal:true

class CreateWorkoutCategories < ActiveRecord::Migration[7.0]
  def change
    create_table :workout_categories do |t|
      t.string :name, null: false

      t.timestamps
    end
    add_index :workout_categories, :name, unique: true
  end
end
