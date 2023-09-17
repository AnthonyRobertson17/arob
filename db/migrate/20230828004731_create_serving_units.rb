# frozen_string_literal: true

class CreateServingUnits < ActiveRecord::Migration[7.0]
  def change
    create_table(:serving_units) do |t|
      t.string(:name, null: false)
      t.string(:abbreviation)

      t.belongs_to(:user)
      t.index([:user_id, :name], unique: true)
      t.timestamps
    end
  end
end
