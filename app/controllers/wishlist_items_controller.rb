# frozen_string_literal:true

class WishlistItemsController < ApplicationController
  before_action(:set_wishlist)
  before_action(:set_wishlist_item, only: [:show, :edit, :update, :destroy])

  def show; end

  def new
    @wishlist_item = WishlistItem.new
  end

  def quick_new
    @wishlist_item = WishlistItem.new
  end

  def edit; end

  def create
    @wishlist_item = @wishlist.wishlist_items.build(wishlist_item_params)

    if @wishlist_item.save
      redirect_to([@wishlist, @wishlist_item], status: :see_other)
    else
      render(:new, status: :unprocessable_entity)
    end
  end

  def quick_create
    @wishlist_item = @wishlist.wishlist_items.build(wishlist_item_params)

    if @wishlist_item.save
      respond_to do |format|
        format.html { redirect_to(wishlist_path(@wishlist)) }
        format.turbo_stream
      end
    else
      render(:quick_new, status: :unprocessable_entity)
    end
  end

  def update
    if @wishlist_item.update(wishlist_item_params)
      respond_to do |format|
        format.html { redirect_to(wishlist_path(@wishlist)) }
        format.turbo_stream
      end
    else
      render(:edit, status: :unprocessable_entity)
    end
  end

  def destroy
    @wishlist_item.destroy

    redirect_to(wishlist_url(@wishlist), status: :see_other)
  end

  private

  def set_wishlist_item
    @wishlist_item = @wishlist.wishlist_items.find(params[:id])
  end

  def wishlist_item_params
    params.require(:wishlist_item).permit(:name)
  end

  def set_wishlist
    @wishlist = current_user.wishlists.find(params[:wishlist_id])
  end
end
