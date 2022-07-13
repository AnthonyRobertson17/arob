# frozen_string_literal: true

class AddNotesToExercises < ActiveRecord::Migration[7.0]
  def change
    add_column(:exercises, :note, :text)
  end
end
