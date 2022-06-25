# frozen_string_literal: true

class ExerciseType < ApplicationRecord
  belongs_to :user

  has_many :exercise_type_tag_assignments, dependent: :destroy
  has_many :tags, through: :exercise_type_tag_assignments

  validates :name, presence: true

  scope :for_user, ->(user) { where(user:) }
end
