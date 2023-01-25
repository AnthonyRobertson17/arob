# frozen_string_literal: true

class Equipment < ApplicationRecord
  belongs_to :user
  has_many :exercise_types, through: :equipment_exercise_types
  has_many :gyms, through: :equipment_gyms

  validates :name, presence: true

  scope :for_user, ->(user) { where(user:) }
end
