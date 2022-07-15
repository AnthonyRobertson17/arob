# frozen_string_literal: true

class Exercise < ApplicationRecord
  belongs_to :workout
  belongs_to :exercise_type
  has_many :exercise_sets, dependent: :destroy

  validates :position, uniqueness: { scope: :workout }

  before_create :set_position

  def set_position
    last_position = workout.exercises.order(position: :desc).first&.position
    self.position = if last_position.present?
                      last_position + 1
                    else
                      0
                    end
  end
end
