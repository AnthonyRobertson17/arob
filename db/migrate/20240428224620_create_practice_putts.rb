# frozen_string_literal: true

class CreatePracticePutts < ActiveRecord::Migration[7.0]
  def change
    create_table(:practice_putts) do |t|
      t.boolean(:sunk, default: false, null: false)
      t.integer(:distance, default: 0, null: false)
      t.integer(:direction, default: 0, null: false)
      t.belongs_to(:putting_practice_session)
      t.timestamps
    end
  end
end
