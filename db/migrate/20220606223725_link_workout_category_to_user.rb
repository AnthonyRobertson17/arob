# frozen_string_literal: true

class LinkWorkoutCategoryToUser < ActiveRecord::Migration[7.0]
  def change
    add_reference(:workout_categories, :user, foreign_key: true)
  end
end
