# frozen_string_literal: true

class ServingUnit < ApplicationRecord
  belongs_to(:user)

  validates(:name, presence: true, uniqueness: { scope: :user_id })

  default_scope { order("lower(name)") }

  scope(:for_user, ->(user) { where(user:) })

  def abbreviated_name
    abbreviation || name
  end

  def abbreviated?
    abbreviation.present?
  end
end
