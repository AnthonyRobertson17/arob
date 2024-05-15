# frozen_string_literal: true

class PracticePutt < ApplicationRecord
  belongs_to :putting_practice_session

  validates(:sunk, inclusion: { in: [true, false] })

  enum :distance, { short: -2, slightly_short: -1, perfect_distance: 0, slightly_long: 1, long: 2 },
       default: :perfect_distance
  enum :direction, { far_left: -3, left: -2, left_lip: -1, straight: 0, right_lip: 1, right: 2, far_right: 3 },
       default: :straight

  validates(:distance, comparison: { equal_to: "perfect_distance", if: :sunk })
  validates(:direction, inclusion: { in: ["left_lip", "straight", "right_lip"], if: :sunk })
end
