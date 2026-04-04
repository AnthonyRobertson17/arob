# frozen_string_literal: true

class CreateGolfPuttingSessions < ActiveRecord::Migration[8.1]
  def change
    create_table(:golf_putting_sessions) do |t|
      t.references(:user, null: false, foreign_key: true)
      t.integer(:session_type, null: false)
      t.datetime(:started_at, null: false)
      t.datetime(:completed_at)

      t.timestamps
    end
  end
end
