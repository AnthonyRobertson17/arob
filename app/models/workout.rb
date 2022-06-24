# frozen_string_literal: true

class Workout < ApplicationRecord
  class AlreadyStartedError < StandardError; end
  class AlreadyCompletedError < StandardError; end
  class NotStartedError < StandardError; end

  belongs_to :user
  has_many :workout_tag_assignments, dependent: :destroy
  has_many :tags, through: :workout_tag_assignments

  validates :name, presence: true

  scope :for_user, ->(user) { where(user:) }
  scope :completed, -> { where.not(completed_at: nil) }
  scope :in_progress, -> { where(completed_at: nil).where.not(started_at: nil) }

  def start!
    raise AlreadyStartedError if started?

    update!(started_at: Time.now.utc)
  end

  def complete!
    raise AlreadyCompletedError if completed?
    raise NotStartedError unless started?

    update!(completed_at: Time.now.utc)
  end

  def started?
    started_at.present?
  end

  def completed?
    completed_at.present?
  end

  def in_progress?
    started? && !completed?
  end

  def draft?
    !started? && !completed?
  end
end
