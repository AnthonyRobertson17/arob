# frozen_string_literal: true

class Workout < ApplicationRecord
  belongs_to :workout_category

  validates :name, presence: true

  scope :completed, -> { where.not(completed_at: nil) }

  def start!
    return if started?

    update!(started_at: Time.now.utc)
  end

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
