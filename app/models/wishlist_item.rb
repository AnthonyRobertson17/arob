# frozen_string_literal: true

class WishlistItem < ApplicationRecord
  belongs_to :wishlist
  has_many :links, as: :linkable, dependent: :destroy

  validates :name, presence: true

  accepts_nested_attributes_for :links, reject_if: :all_blank, allow_destroy: true
end
