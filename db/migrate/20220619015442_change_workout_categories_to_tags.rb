# frozen_string_literal: true

class ChangeWorkoutCategoriesToTags < ActiveRecord::Migration[7.0]
  def change
    rename_table :workout_categories, :tags
  end
end
