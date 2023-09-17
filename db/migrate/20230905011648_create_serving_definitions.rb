# frozen_string_literal: true

class CreateServingDefinitions < ActiveRecord::Migration[7.0]
  def change
    create_table(:serving_definitions) do |t|
      t.timestamps
      t.decimal(:serving_quantity)

      t.references(:user)
      t.references(:food)
      t.references(:food_group)
      t.references(:serving_unit)
    end
  end
end
