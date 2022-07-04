# frozen_string_literal: true

class Exercise < ApplicationRecord
  belongs_to :workout
  belongs_to :exercise_type
end
