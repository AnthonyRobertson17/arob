# frozen_string_literal: true

class Wishlist < ApplicationRecord
  belongs_to :user

  validates :name, presence: true

  scope :for_user, ->(user) { where(user:) }
end
