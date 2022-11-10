# frozen_string_literal: true

require "application_system_test_case"

class WishlistItemsTest < ApplicationSystemTestCase
  test "creating wishlist item" do
    user = login
    wishlist = create(:wishlist, user:)

    visit(wishlist_url(wishlist))
    click_on("Add New Item")

    fill_in("Name", with: "Random wishlist item name")
    click_on("Create")

    assert_text("Random wishlist item name")
  end

  test "quick creating wishlist item" do
    user = login
    wishlist = create(:wishlist, user:)

    visit(wishlist_url(wishlist))
    click_on("Quick Add")

    fill_in("Name", with: "Random wishlist item name")
    click_on("Create")

    assert_text("Random wishlist item name")
  end

  test "cancel creating a wishlist item" do
    user = login
    wishlist = create(:wishlist, user:)

    visit(wishlist_url(wishlist))
    click_on("Add New Item")
    click_on("Cancel")

    assert_current_path(wishlist_path(wishlist))
  end

  test "cancel quick creating a wishlist item" do
    user = login
    wishlist = create(:wishlist, user:)

    visit(wishlist_url(wishlist))
    click_on("Quick Add")
    click_on("Cancel")

    assert_current_path(wishlist_path(wishlist))
    assert_no_text("Random wishlist item name")
  end

  test "editing wishlist Items" do
    user = login
    wishlist = create(:wishlist, user:)
    wishlist_item = create(:wishlist_item, wishlist:)

    visit(wishlist_wishlist_item_url(wishlist, wishlist_item))
    find(".bi-pencil").click

    fill_in("Name", with: "something else")
    click_on("Update")

    assert_current_path(wishlist_wishlist_item_path(wishlist, wishlist_item))
    assert_text("something else")
  end

  test "cancel editing a wishlist item" do
    user = login
    wishlist = create(:wishlist, user:)
    wishlist_item = create(:wishlist_item, wishlist:)

    visit(wishlist_wishlist_item_url(wishlist, wishlist_item))
    find(".bi-pencil").click

    fill_in("Name", with: "something else")
    click_on("Cancel")

    assert_current_path(wishlist_wishlist_item_path(wishlist, wishlist_item))
    assert_no_text("something else")
  end

  test "destroying Wishlist" do
    user = login
    wishlist = create(:wishlist, user:)
    wishlist_item = create(:wishlist_item, wishlist:)

    visit(wishlist_wishlist_item_url(wishlist, wishlist_item))
    find(".bi-pencil").click
    accept_confirm do
      find(".bi-trash3").click
    end

    assert_current_path(wishlist_path(wishlist))
    assert_no_text("should be gone")
  end
end
