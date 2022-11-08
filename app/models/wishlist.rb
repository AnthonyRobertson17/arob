# frozen_string_literal: true

class Wishlist < ApplicationRecord
  belongs_to :user
  has_many :wishlist_items, dependent: :destroy

  validates :name, presence: true

  scope :for_user, ->(user) { where(user:) }
end
