# frozen_string_literal: true

require "application_system_test_case"

class WishlistItemsTest < ApplicationSystemTestCase
  test "creating wishlist item" do
    user = login
    wishlist = create(:wishlist, user:)

    visit(wishlist_url(wishlist))
    click_on("Add New Item")

    fill_in("Name", with: "Random wishlist item name")
    fill_in("Description", with: "Some random description")
    fill_in("Price", with: 12.5)
    click_on("Add Link")
    fill_in(id: /wishlist_item_links_attributes_[0-9]{10,}_url/, with: "https://google.com")
    click_on("Create")

    assert_text("Random wishlist item name")
    assert_text("Some random description")
    assert_link("https://google.com")
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
    links = [create(:link)]
    wishlist_item = create(:wishlist_item, wishlist:, links:)

    visit(wishlist_wishlist_item_url(wishlist, wishlist_item))
    find(".bi-pencil").click

    fill_in("Name", with: "something else")
    fill_in("Description", with: "some other description")
    fill_in("Price", with: 20.56)
    fill_in(id: "wishlist_item_links_attributes_0_url", with: "https://foobar.com")
    click_on("Update")

    assert_current_path(wishlist_wishlist_item_path(wishlist, wishlist_item))
    assert_text("something else")
    assert_text("some other description")
    assert_text("$20.56")
    assert_link("https://foobar.com")
  end

  test "deleting a link" do
    user = login
    wishlist = create(:wishlist, user:)
    links = [create(:link)]
    wishlist_item = create(:wishlist_item, wishlist:, links:)

    visit(wishlist_wishlist_item_url(wishlist, wishlist_item))
    find(".bi-pencil").click

    first(".bi-trash3").click
    click_on("Update")

    assert_current_path(wishlist_wishlist_item_path(wishlist, wishlist_item))

    wishlist_item.reload

    assert_equal(0, wishlist_item.links.count)
  end

  test "adding a new link when updating" do
    user = login
    wishlist = create(:wishlist, user:)
    links = [create(:link, url: "https://silly.com")]
    wishlist_item = create(:wishlist_item, wishlist:, links:)

    visit(wishlist_wishlist_item_url(wishlist, wishlist_item))
    find(".bi-pencil").click

    click_on("Add Link")
    fill_in(id: /wishlist_item_links_attributes_[0-9]{10,}_url/, with: "https://foobar.com")
    click_on("Update")

    assert_current_path(wishlist_wishlist_item_path(wishlist, wishlist_item))

    wishlist_item.reload

    assert_link("https://foobar.com")
    assert_link("https://silly.com")
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
      all(".bi-trash3").last.click
    end

    assert_current_path(wishlist_path(wishlist))
    assert_no_text("should be gone")
  end
end
