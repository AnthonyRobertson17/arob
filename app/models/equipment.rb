# frozen_string_literal: true

class Equipment < ApplicationRecord
  belongs_to(:user)
  has_and_belongs_to_many(:gyms)
  has_and_belongs_to_many(:exercise_types)

  validates(:name, presence: true)

  default_scope { order("lower(name)") }

  scope(:for_user, ->(user) { where(user:) })
end
