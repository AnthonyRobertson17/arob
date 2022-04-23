# frozen_string_literal: true

class Workout < ApplicationRecord
  belongs_to :workout_category

  validates :name, presence: true

  def started?
    started_at.present?
  end

  def completed?
    completed_at.present?
  end

  def active?
    started? && !completed?
  end
end
