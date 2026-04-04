# frozen_string_literal: true

class CreateGolfPutts < ActiveRecord::Migration[8.1]
  def change
    create_table(:golf_putts) do |t|
      t.references(:putting_session, null: false, foreign_key: { to_table: :golf_putting_sessions })
      t.boolean(:holed, null: false, default: false)
      t.integer(:pace)
      t.integer(:direction)
      t.integer(:distance_feet)

      t.timestamps
    end
  end
end
