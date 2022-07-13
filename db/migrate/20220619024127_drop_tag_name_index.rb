# frozen_string_literal: true

class DropTagNameIndex < ActiveRecord::Migration[7.0]
  def change
    remove_index(:tags, :name)
  end
end
