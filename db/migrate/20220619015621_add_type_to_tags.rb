# frozen_string_literal: true

class AddTypeToTags < ActiveRecord::Migration[7.0]
  def change
    add_column(:tags, :type, :string)
  end
end
