# frozen_string_literal: true

class CreateTagIndexForNameAndUserId < ActiveRecord::Migration[7.0]
  def change
    add_index :tags, [:name, :user_id]
  end
end
