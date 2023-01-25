# frozen_string_literal: true

class WishlistsController < ApplicationController
  before_action(:set_wishlist, only: [:edit, :update, :destroy])

  # GET /wishlists
  def index
    @wishlists = policy_scope(Wishlist).all.order(id: :desc)
  end

  # GET /wishlists/1
  def show
    @wishlist = policy_scope(Wishlist).includes(:wishlist_items).find(params[:id])
  end

  # GET /wishlists/new
  def new
    @wishlist = Wishlist.new
  end

  # GET /wishlists/1/edit
  def edit; end

  # POST /wishlists
  def create
    @wishlist = Wishlist.new(wishlist_params.merge(user: current_user))

    if @wishlist.save
      redirect_to(@wishlist)
    else
      render(:new, status: :unprocessable_entity)
    end
  end

  # PATCH/PUT /wishlists/1
  def update
    if @wishlist.update(wishlist_params)
      respond_to do |format|
        format.html { redirect_to(@wishlist) }
        format.turbo_stream
      end
    else
      render(:edit, status: :unprocessable_entity)
    end
  end

  # DELETE /wishlists/1
  def destroy
    @wishlist.destroy
    redirect_to(wishlists_url, status: :see_other)
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_wishlist
    @wishlist = policy_scope(Wishlist).find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def wishlist_params
    params.require(:wishlist).permit(:name)
  end
end
