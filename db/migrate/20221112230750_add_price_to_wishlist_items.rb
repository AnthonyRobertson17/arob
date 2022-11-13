# frozen_string_literal: true

class AddPriceToWishlistItems < ActiveRecord::Migration[7.0]
  def change
    add_column(:wishlist_items, :price, :decimal, precision: 8, scale: 2)
  end
end
