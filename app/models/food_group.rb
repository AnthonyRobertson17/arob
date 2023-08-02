# frozen_string_literal: true

class FoodGroup < ApplicationRecord
  belongs_to(:user)

  validates(:name, presence: true, uniqueness: { scope: :user_id })
  validates(:emoji, length: { maximum: 1 })

  default_scope { order("lower(name)") }

  scope(:for_user, ->(user) { where(user:) })

  def name_with_emoji
    "#{emoji} #{name}"
  end
end
