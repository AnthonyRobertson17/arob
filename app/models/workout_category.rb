# frozen_string_literal:true

class WorkoutCategory < ApplicationRecord
  belongs_to :user
  has_many :workouts, dependent: :nullify

  validates :name, presence: true

  scope :for_user, ->(user) { where(user:) }
end
