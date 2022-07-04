# frozen_string_literal: true

class AddUniquenessIndexes < ActiveRecord::Migration[7.0]
  def change
    add_index :exercise_types, [:user_id, :name], unique: true
    add_index :tags, [:user_id, :name, :type], unique: true
  end
end
