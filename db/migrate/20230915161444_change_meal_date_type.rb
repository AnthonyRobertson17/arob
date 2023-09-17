# frozen_string_literal: true

class ChangeMealDateType < ActiveRecord::Migration[7.0]
  def change
    change_table(:meals) do |t|
      t.change(:date, :datetime) # rubocop:disable Rails/ReversibleMigration
    end
  end
end
