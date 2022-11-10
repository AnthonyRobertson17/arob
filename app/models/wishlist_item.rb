# frozen_string_literal: true

class WishlistItem < ApplicationRecord
  belongs_to :wishlist

  validates :name, presence: true
end
