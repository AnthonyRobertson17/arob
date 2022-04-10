# frozen_string_literal:true

class WorkoutCategory < ApplicationRecord
  validates :name, presence: true
end
