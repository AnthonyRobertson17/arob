# frozen_string_literal: true

class CreateFoodGroups < ActiveRecord::Migration[7.0]
  def change
    create_table(:food_groups) do |t|
      t.string(:name, null: false)
      t.string(:emoji, limit: 1, null: false)

      t.belongs_to(:user)

      t.index([:user_id, :name], unique: true)

      t.timestamps
    end
  end
end
