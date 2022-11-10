# frozen_string_literal: true

require "test_helper"

class WishlistItemTest < ActiveSupport::TestCase
  test "name is required" do
    wishlist_item = build(:wishlist_item, name: "")

    assert_predicate(wishlist_item, :invalid?)
  end
end
