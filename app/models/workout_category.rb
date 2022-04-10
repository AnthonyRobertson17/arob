# frozen_string_literal:true

class WorkoutCategory < ApplicationRecord
  has_many :workouts, dependent: :nullify
  validates :name, presence: true
end
