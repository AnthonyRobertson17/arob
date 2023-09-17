# frozen_string_literal: true

class CreatePortions < ActiveRecord::Migration[7.0]
  def change
    create_table(:portions) do |t|
      t.decimal(:serving_quantity, null: false)

      t.references(:user)
      t.references(:food_group)
      t.references(:meal)
      t.references(:food)
      t.timestamps
    end
  end
end
