# frozen_string_literal: true

class LinkWorkoutsWithUsers < ActiveRecord::Migration[7.0]
  def change
    add_reference :workouts, :user, foreign_key: true
  end
end
