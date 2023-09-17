# frozen_string_literal: true

class CreateMeals < ActiveRecord::Migration[7.0]
  def change
    create_table(:meals) do |t|
      t.timestamps
      t.date(:date)
      t.integer(:meal_type, default: 0, null: false)
      t.string(:name)

      t.references(:user)
    end
  end
end
