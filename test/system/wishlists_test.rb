# frozen_string_literal: true

require "application_system_test_case"

class WishlistsTest < ApplicationSystemTestCase
  test "visiting the index" do
    user = login
    create(:wishlist, user:)

    visit(wishlists_url)

    assert_selector("h1", text: "Wishlists")
  end

  test "creating wishlist" do
    login

    visit(wishlists_url)
    click_on("Create Wishlist")

    fill_in("Name", with: "Random wishlist name")
    click_on("Create")

    assert_text("Random wishlist name")
  end

  test "cancel creating a wishlist" do
    login
    visit(new_wishlist_url)

    click_on("Cancel")

    assert_selector("h1", text: "Wishlists")
  end

  test "editing Wishlists" do
    user = login
    wishlist = create(:wishlist, user:)

    visit(wishlist_url(wishlist))
    find(".bi-pencil").click

    assert_current_path(wishlist_path(wishlist))

    fill_in("Name", with: "something else")
    click_on("Update")

    assert_text("something else")
  end

  test "cancel editing a wishlist" do
    user = login
    wishlist = create(:wishlist, user:)

    visit(edit_wishlist_url(wishlist))
    click_on("Cancel")
  end

  test "destroying Wishlist" do
    user = login
    wishlist = create(:wishlist, user:, name: "should be gone")

    visit(wishlist_url(wishlist))
    find(".bi-pencil").click
    accept_confirm do
      find(".bi-trash3").click
    end

    assert_no_text("should be gone")
  end
end
