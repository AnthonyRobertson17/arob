# frozen_string_literal: true

class CreateWishlistItems < ActiveRecord::Migration[7.0]
  def change
    create_table(:wishlist_items) do |t|
      t.string(:name, null: false)
      t.belongs_to(:wishlist)

      t.timestamps
    end
  end
end
