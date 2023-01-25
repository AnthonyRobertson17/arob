# frozen_string_literal: true

class CreateEquipment < ActiveRecord::Migration[7.0]
  def change
    create_table(:equipment) do |t|
      t.string(:name, null: false)
      t.belongs_to(:user)

      t.timestamps
    end

    create_join_table(:equipment, :gyms)
    create_join_table(:equipment, :exercise_types)
  end
end
