# frozen_string_literal: true

class ExerciseSet < ApplicationRecord
  belongs_to(:exercise)

  validates(:weight, numericality: { greater_than_or_equal_to: 0 })
  validates(:repetitions, numericality: { greater_than_or_equal_to: 0 })
end
