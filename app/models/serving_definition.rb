# frozen_string_literal: true

class ServingDefinition < ApplicationRecord
  belongs_to(:user)
  belongs_to(:food_group)
  belongs_to(:food)
  belongs_to(:serving_unit)

  validates(:serving_quantity, presence: true, numericality: { greater_than_or_equal_to: 0 })

  validate :food_belongs_to_food_group

  scope(:for_user, ->(user) { where(user:) })

  private

  def food_belongs_to_food_group
    return if food.food_groups.exists?(id: food_group.id)

    errors.add(:food, "does not blong to the chosen food group")
  end
end
