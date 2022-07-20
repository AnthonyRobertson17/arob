# frozen_string_literal: true

class Exercise < ApplicationRecord
  belongs_to :workout
  belongs_to :exercise_type
  has_many :exercise_sets, dependent: :destroy

  before_validation :initialize_position
  after_destroy :update_workout

  validates :position, uniqueness: { scope: :workout }, numericality: { greater_than_or_equal_to: 0 }
  delegate :name, to: :exercise_type

  def initialize_position
    return unless new_record?

    self.position = workout.exercises.count
  end

  def update_workout
    workout.handle_exercise_deletion(position)
  end
end
