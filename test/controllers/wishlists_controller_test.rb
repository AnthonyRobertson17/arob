# frozen_string_literal: true

require "test_helper"

class WishlistsControllerTest < ActionDispatch::IntegrationTest
  def user
    @user ||= create(:user)
  end

  setup do
    sign_in(user)
  end

  test "get index" do
    create(:wishlist, user:)

    get(wishlists_url)

    assert_response(:success)
  end

  test "get index only returns current users wishlists" do
    create(:wishlist, user:, name: "funny wishlist")
    create(:wishlist, name: "should not be shown")

    get(wishlists_url)

    assert_select("h3", { text: /funny wishlist/, count: 1 })
    assert_select("h3", { text: /should not be shown/, count: 0 })
  end

  test "get index lists wishlists in reverse chronological order" do
    create(:wishlist, user:, name: "AAAAAAAAAAAA")
    create(:wishlist, user:, name: "BBB")
    create(:wishlist, user:, name: "CCCCCCCCCCCC")

    get(wishlists_url)

    first = response.body.index("AAAAAAAAAAAA")
    second = response.body.index("BBB")
    third = response.body.index("CCCCCCCCCCCC")

    assert(first > second, "wishlists are not in reverse chronological order")
    assert(second > third, "wishlists are not in reverse chronological order")
  end

  test "get new" do
    get(new_wishlist_url)

    assert_response(:success)
  end

  test "create wishlist redirects to the correct wishlist" do
    assert_difference("Wishlist.count") do
      post(wishlists_url, params: { wishlist: { name: "New wishlist name" } })
    end

    assert_redirected_to(wishlist_url(Wishlist.last))
  end

  test "create wishlist links to the current_user" do
    post(wishlists_url, params: { wishlist: { name: "New wishlist name" } })

    new_wishlist = Wishlist.for_user(@user).last

    assert_equal("New wishlist name", new_wishlist.name)
  end

  test "show wishlist includes name" do
    wishlist = create(:wishlist, user:, name: "testing 123")

    get(wishlist_url(wishlist))

    assert_response(:success)
    assert_select("h1", { text: /testing 123/, count: 1 })
  end

  test "show wishlist raises not found if the wishlist belongs to another user" do
    wishlist = create(:wishlist)

    assert_raises(ActiveRecord::RecordNotFound) do
      get(wishlist_url(wishlist))
    end
  end

  test "get edit" do
    wishlist = create(:wishlist, user:)
    get(edit_wishlist_url(wishlist))

    assert_response(:success)
  end

  test "get edit raises not found if the wishlist belongs to another user" do
    wishlist = create(:wishlist)

    assert_raises(ActiveRecord::RecordNotFound) do
      get(edit_wishlist_url(wishlist))
    end
  end

  test "update wishlist name" do
    wishlist = create(:wishlist, user:)

    patch(wishlist_url(wishlist), params: { wishlist: { name: "Updated wishlist name" } })

    wishlist.reload

    assert_equal("Updated wishlist name", wishlist.name)
  end

  test "update wishlist with html format redirects to the wishlist show page" do
    wishlist = create(:wishlist, user:)
    patch(wishlist_url(wishlist), params: { wishlist: { name: "Updated wishlist name" } })

    assert_redirected_to(wishlist_url(wishlist))
  end

  test "update wishlist with turbo_stream format responds with OK" do
    wishlist = create(:wishlist, user:)
    patch(wishlist_url(wishlist, format: :turbo_stream), params: { wishlist: { name: "Updated wishlist name" } })

    assert_response(:ok)
  end

  test "update wishlist raises not found if the wishlist belongs to another user" do
    wishlist = create(:wishlist)

    assert_raises(ActiveRecord::RecordNotFound) do
      patch(wishlist_url(wishlist), params: { wishlist: { name: "Updated wishlist name" } })
    end
  end

  test "destroy wishlist" do
    wishlist = create(:wishlist, user:)
    assert_difference("Wishlist.count", -1) do
      delete(wishlist_url(wishlist))
    end

    assert_redirected_to(wishlists_url)
  end

  test "destroy wishlist raises not found if the wishlist belongs to another user" do
    wishlist = create(:wishlist)

    assert_raises(ActiveRecord::RecordNotFound) do
      delete(wishlist_url(wishlist))
    end
  end
end
