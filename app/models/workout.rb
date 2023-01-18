# frozen_string_literal: true

class Workout < ApplicationRecord
  class AlreadyStartedError < StandardError; end
  class AlreadyCompletedError < StandardError; end
  class NotStartedError < StandardError; end

  belongs_to :user
  has_many :workout_tag_assignments, dependent: :destroy
  has_many :tags, through: :workout_tag_assignments
  has_many :exercises, -> { order(:position) }, inverse_of: :workout, dependent: :destroy

  validates :name, presence: true

  scope :for_user, ->(user) { where(user:) }
  scope :completed, -> { where.not(completed_at: nil) }
  scope :in_progress, -> { where(completed_at: nil).where.not(started_at: nil) }

  def start!
    raise(AlreadyStartedError) if started?

    update!(started_at: Time.now.utc)
  end

  def complete!
    raise(AlreadyCompletedError) if completed?
    raise(NotStartedError) unless started?

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

  def last_exercise?(exercise)
    exercise.position == last_exercise_position
  end

  def last_exercise_position
    count = exercises.count - 1
    return nil if count.negative?

    count
  end

  def handle_exercise_deletion(position)
    exercises.where(position: position...).order(:position).each do |exercise|
      exercise.decrement(:position)
      exercise.save!
    end
  end
end
