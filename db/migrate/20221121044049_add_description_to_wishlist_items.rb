# frozen_string_literal: true

class AddDescriptionToWishlistItems < ActiveRecord::Migration[7.0]
  def change
    add_column(:wishlist_items, :description, :text)
  end
end
