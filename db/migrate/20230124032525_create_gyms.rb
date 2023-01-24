# frozen_string_literal: true

class CreateGyms < ActiveRecord::Migration[7.0]
  def change
    create_table(:gyms) do |t|
      t.string(:name, null: false)
      t.belongs_to(:user)

      t.timestamps
    end
  end
end
