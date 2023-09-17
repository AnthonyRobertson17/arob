# frozen_string_literal: true

class Portion < ApplicationRecord
  belongs_to(:user)
  belongs_to(:meal)
  belongs_to(:food)
  belongs_to(:food_group)
  has_many :serving_definitons, -> { where(food_group:) }, through: :food

  validates(:serving_quantity, presence: true, numericality: { greater_than: 0 })

  validate :food_belongs_to_food_group

  scope(:for_user, ->(user) { where(user:) })

  private

  def food_belongs_to_food_group
    return if food.food_groups.exists?(id: food_group.id)

    errors.add(:food, "does not blong to the chosen food group")
  end
end
