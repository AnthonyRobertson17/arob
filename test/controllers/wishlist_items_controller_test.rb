# frozen_string_literal:true

require "test_helper"

class WishlistItemsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = create(:user)
    sign_in(@user)
    @wishlist = create(:wishlist, user: @user)
  end

  test "get new" do
    get(new_wishlist_wishlist_item_url(@wishlist))

    assert_response(:success)
  end

  test "get quick_new" do
    get(quick_new_wishlist_wishlist_items_url(@wishlist))

    assert_response(:success)
  end

  test "create wishlist item creates a new record" do
    assert_difference("WishlistItem.count") do
      post(
        wishlist_wishlist_items_url(@wishlist),
        params: {
          wishlist_item: {
            name: "New wishlist item",
          },
        },
      )
    end
  end

  test "create wishlist item links new record to the correct wishlist" do
    post(
      wishlist_wishlist_items_url(@wishlist),
      params: {
        wishlist_item: {
          name: "Foobar",
        },
      },
    )

    new_wishlist_item = @wishlist.wishlist_items.first

    assert_equal("Foobar", new_wishlist_item.name)
  end

  test "create wishlist item redirects to the new wishlist item" do
    post(
      wishlist_wishlist_items_url(@wishlist),
      params: {
        wishlist_item: {
          name: "Foobar",
        },
      },
    )
    wishlist_item = WishlistItem.last

    assert_redirected_to([@wishlist, wishlist_item])
  end

  test "quick_create wishlist item creates a new record" do
    assert_difference("WishlistItem.count") do
      post(
        quick_create_wishlist_wishlist_items_url(@wishlist),
        params: {
          wishlist_item: {
            name: "New wishlist item",
          },
        },
      )
    end
  end

  test "quick_create wishlist item links new record to the correct wishlist" do
    post(
      quick_create_wishlist_wishlist_items_url(@wishlist),
      params: {
        wishlist_item: {
          name: "Foobar",
        },
      },
    )

    new_wishlist_item = @wishlist.wishlist_items.first

    assert_equal("Foobar", new_wishlist_item.name)
  end

  test "quick_create wishlist item with html format redirects to the related wishlist" do
    post(
      quick_create_wishlist_wishlist_items_url(@wishlist),
      params: {
        wishlist_item: {
          name: "Foobar",
        },
      },
    )

    assert_redirected_to([@wishlist])
  end

  test "quick_create wishlist item with turbostream format returns 200 OK" do
    post(
      quick_create_wishlist_wishlist_items_url(@wishlist, format: :turbo_stream),
      params: {
        wishlist_item: {
          name: "Foobar",
        },
      },
    )

    assert_response(:ok)
  end

  test "get edit" do
    wishlist_item = create(:wishlist_item, wishlist: @wishlist)

    get(edit_wishlist_wishlist_item_url(@wishlist, wishlist_item))

    assert_response(:success)
  end

  test "get edit raises not found if corresponding wishlist does not belong to the current user" do
    other_user = create(:user)
    other_wishlist = create(:wishlist, user: other_user)
    other_wishlist_item = create(:wishlist_item, wishlist: other_wishlist)

    assert_raises(ActiveRecord::RecordNotFound) do
      get(edit_wishlist_wishlist_item_url(other_wishlist, other_wishlist_item))
    end
  end

  test "update wishlist item actually updates the record" do
    wishlist_item = create(:wishlist_item, wishlist: @wishlist)

    patch(
      wishlist_wishlist_item_url(@wishlist, wishlist_item),
      params: {
        wishlist_item: {
          name: "This is a fancy new name",
        },
      },
    )

    wishlist_item.reload

    assert_equal("This is a fancy new name", wishlist_item.name)
  end

  test "update wishlist item with html format redirects to the associated wishlist" do
    wishlist_item = create(:wishlist_item, wishlist: @wishlist)

    patch(
      wishlist_wishlist_item_url(@wishlist, wishlist_item),
      params: {
        wishlist_item: {
          name: "This is a fancy new name",
        },
      },
    )

    assert_redirected_to(wishlist_path(@wishlist))
  end

  test "update wishlist item with turbo_stream format responds with OK" do
    wishlist_item = create(:wishlist_item, wishlist: @wishlist)

    patch(
      wishlist_wishlist_item_url(@wishlist, wishlist_item, format: :turbo_stream),
      params: {
        wishlist_item: {
          name: "This is a fancy new name",
        },
      },
    )

    assert_response(:ok)
  end

  test "update wishlist item raises not found if associated wishlist belongs to another user" do
    other_user = create(:user)
    other_wishlist = create(:wishlist, user: other_user)
    other_wishlist_item = create(:wishlist_item, wishlist: other_wishlist)

    assert_raises(ActiveRecord::RecordNotFound) do
      patch(
        wishlist_wishlist_item_url(other_wishlist, other_wishlist_item),
        params: {
          wishlist_item: {
            name: "This is a fancy new name",
          },
        },
      )
    end
  end

  test "destroy wishlist item destroys the record" do
    wishlist_item = create(:wishlist_item, wishlist: @wishlist)

    assert_difference("WishlistItem.count", -1) do
      delete(wishlist_wishlist_item_url(@wishlist, wishlist_item))
    end
  end

  test "destroy wishlist item redirects to the associated wishlist page" do
    wishlist_item = create(:wishlist_item, wishlist: @wishlist)

    delete(wishlist_wishlist_item_url(@wishlist, wishlist_item))

    assert_redirected_to(wishlist_path(@wishlist))
  end

  test "destroy wishlist item raises not found if associated wishlist belongs to another user" do
    other_user = create(:user)
    other_wishlist = create(:wishlist, user: other_user)
    other_wishlist_item = create(:wishlist_item, wishlist: other_wishlist)

    assert_raises(ActiveRecord::RecordNotFound) do
      delete(wishlist_wishlist_item_url(other_wishlist, other_wishlist_item))
    end
  end
end
