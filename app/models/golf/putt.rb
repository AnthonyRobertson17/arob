# frozen_string_literal: true

module Golf
  class Putt < ApplicationRecord
    self.table_name = "golf_putts"

    belongs_to :putting_session, class_name: "Golf::PuttingSession"

    enum :pace, { perfect: 0, too_hard: 1, too_soft: 2 }
    enum :direction, { on_target: 0, left: 1, right: 2 }

    validates :holed, inclusion: { in: [true, false] }
    validates :distance_feet, numericality: { greater_than: 0, allow_nil: true }

    scope :holed, -> { where(holed: true) }
    scope :missed, -> { where(holed: false) }
  end
end
