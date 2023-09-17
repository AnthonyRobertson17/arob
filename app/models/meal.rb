# frozen_string_literal: true

class Meal < ApplicationRecord
  belongs_to :user

  has_many :portions, dependent: :destroy

  enum :meal_type, [:breakfast, :lunch, :dinner, :dessert, :snack]

  validates :meal_type, presence: true

  scope :for_user, ->(user) { where(user:) }

  def full_name
    return self[:name] if self[:name].present?

    I18n.t("activerecord.attributes.meal.meal_types.#{meal_type}")
  end
end
