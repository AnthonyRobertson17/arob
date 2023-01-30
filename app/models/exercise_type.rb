# frozen_string_literal: true

class ExerciseType < ApplicationRecord
  belongs_to(:user)

  has_many(:exercise_type_tag_assignments, dependent: :destroy)
  has_many(:tags, through: :exercise_type_tag_assignments)
  has_many(:exercises, dependent: :nullify)

  has_and_belongs_to_many(:equipment)

  validates(:name, presence: true, uniqueness: { scope: :user_id })

  default_scope { order("lower(name)") }

  scope(:for_user, ->(user) { where(user:) })
end
