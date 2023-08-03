# frozen_string_literal: true

class Food < ApplicationRecord
  belongs_to(:user)
  has_and_belongs_to_many(:food_groups)

  validates(:name, presence: true, uniqueness: { scope: :user_id })

  default_scope { order("lower(name)") }

  scope(:for_user, ->(user) { where(user:) })
end
