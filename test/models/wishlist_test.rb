# frozen_string_literal: true

require "test_helper"

class WishlistTest < ActiveSupport::TestCase
  test "name is required" do
    wishlist = build(:wishlist, name: "")

    assert_predicate(wishlist, :invalid?)
  end

  test "for_user scope only returns wishlists for the provided user" do
    user = create(:user)
    create(:wishlist)
    create(:wishlist, user:)

    assert_predicate(Wishlist.for_user(user), :one?)
  end
end
