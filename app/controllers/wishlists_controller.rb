# frozen_string_literal: true

class WishlistsController < ApplicationController
  before_action(:set_wishlist, only: [:edit, :update, :destroy])

  # GET /workouts
  def index
    @wishlists = users_wishlists.all.order(id: :desc)
  end

  # GET /workouts/1
  def show
    @wishlist = users_wishlists.find(params[:id])
  end

  # GET /workouts/new
  def new
    @wishlist = Wishlist.new
  end

  # GET /workouts/1/edit
  def edit; end

  # POST /workouts
  def create
    @wishlist = Wishlist.new(wishlist_params.merge(user: current_user))

    if @wishlist.save
      redirect_to(@wishlist)
    else
      render(:new, status: :unprocessable_entity)
    end
  end

  # PATCH/PUT /workouts/1
  def update
    if @wishlist.update(wishlist_params)
      respond_to do |format|
        format.html { redirect_to(@wishlist) }
        format.turbo_stream
      end
    else
      set_wishlist_tags
      render(:edit, status: :unprocessable_entity)
    end
  end

  # DELETE /workouts/1
  def destroy
    @wishlist.destroy
    redirect_to(wishlists_url, status: :see_other)
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_wishlist
    @wishlist = users_wishlists.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def wishlist_params
    params.require(:wishlist).permit(:name)
  end

  def users_wishlists
    Wishlist.for_user(current_user)
  end
end
