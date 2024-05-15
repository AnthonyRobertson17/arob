# frozen_string_literal: true

class PuttingPracticeSession < ApplicationRecord
  belongs_to(:user)
  has_many(:practice_putts, dependent: :destroy)

  enum :hole_size, { normal_hole: 0, small_hole: 1 }, default: :normal_hole, validate: true

  validates(:hole_distance, presence: true, numericality: { greater_than: 0 })

  scope(:for_user, ->(user) { where(user:) })
end
