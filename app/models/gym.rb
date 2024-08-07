# frozen_string_literal: true

class Gym < ApplicationRecord
  belongs_to(:user)
  has_and_belongs_to_many(:equipment)

  validates(:name, presence: true)

  default_scope { order("lower(name)") }

  scope(:for_user, ->(user) { where(user:) })
end
