# frozen_string_literal: true

class ServingDefinition < ApplicationRecord
  belongs_to(:user)
  belongs_to(:food_group)
  belongs_to(:food)
  belongs_to(:serving_unit)

  validates(:serving_quantity, presence: true, numericality: { greater_than_or_equal_to: 0 })

  scope(:for_user, ->(user) { where(user:) })
end
