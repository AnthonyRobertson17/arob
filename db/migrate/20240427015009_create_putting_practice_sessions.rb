# frozen_string_literal: true

class CreatePuttingPracticeSessions < ActiveRecord::Migration[7.0]
  def change
    create_table(:putting_practice_sessions) do |t|
      t.decimal(:hole_distance, default: 3.0, null: false)
      t.integer(:hole_size, default: 0, null: false)
      t.belongs_to(:user)
      t.timestamps
    end
  end
end
