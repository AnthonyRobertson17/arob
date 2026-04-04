# frozen_string_literal: true

module Golf
  class PuttingSession < ApplicationRecord
    self.table_name = "golf_putting_sessions"

    belongs_to :user
    has_many :putts, class_name: "Golf::Putt", dependent: :destroy

    enum :session_type, { putting_mat: 0, practice_green: 1 }

    validates :session_type, presence: true
    validates :started_at, presence: true

    scope :for_user, ->(user) { where(user:) }
    scope :completed, -> { where.not(completed_at: nil) }
    scope :in_progress, -> { where(completed_at: nil) }

    def in_progress?
      completed_at.nil?
    end

    def completed?
      completed_at.present?
    end

    def make_percentage
      return nil if putts.empty?

      (putts.holed.count.to_f / putts.count * 100).round(1)
    end

    def last_distance
      putts.order(created_at: :desc).pick(:distance_feet) || 6
    end

    def complete!
      raise(AlreadyCompletedError) if completed?

      update!(completed_at: Time.current)
    end

    class AlreadyCompletedError < StandardError; end
  end
end
