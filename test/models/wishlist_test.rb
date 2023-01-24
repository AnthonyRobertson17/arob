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

  test "for_user scope only returns gyms for the provided user" do
    user = create(:user)
    expected = create(:wishlist, user:)
    create(:wishlist)

    wishlists = Wishlist.for_user(user)

    assert_predicate(wishlists, :one?)
    assert_equal(expected.id, wishlists.first.id)
  end
end
