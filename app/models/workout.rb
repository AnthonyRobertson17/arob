# frozen_string_literal: true

class Workout < ApplicationRecord
  class AlreadyStartedError < StandardError; end
  class AlreadyCompletedError < StandardError; end
  class NotStartedError < StandardError; end

  belongs_to :user
  belongs_to :workout_category

  validates :name, presence: true
  validate :user_owns_workout_category

  scope :for_user, ->(user) { where(user:) }
  scope :completed, -> { where.not(completed_at: nil) }

  def start!
    raise AlreadyStartedError if started?

    update!(started_at: Time.now.utc)
  end

  def started?
    started_at.present?
  end

  def complete!
    raise AlreadyCompletedError if completed?
    raise NotStartedError unless started?

    update!(completed_at: Time.now.utc)
  end

  def completed?
    completed_at.present?
  end

  def active?
    started? && !completed?
  end

  private

  def user_owns_workout_category
    return if user == workout_category.user

    errors.add(:workout_category, "not found")
  end
end
