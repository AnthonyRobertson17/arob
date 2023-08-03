# frozen_string_literal: true

class CreateFood < ActiveRecord::Migration[7.0]
  def change
    create_table(:foods) do |t|
      t.string(:name, null: false)
      t.timestamps

      t.belongs_to(:user)
      t.index([:user_id, :name], unique: true)
    end

    create_join_table(:food_groups, :foods)
  end
end
