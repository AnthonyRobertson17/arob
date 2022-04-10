# frozen_string_literal: true

class Workout < ApplicationRecord
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
