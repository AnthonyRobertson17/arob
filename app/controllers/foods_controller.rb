# frozen_string_literal:true

class FoodsController < ApplicationController
  before_action(:load_related_models, only: [:new, :edit])

  # GET /foods
  def index
    @foods = policy_scope(Food).all
  end

  # GET /foods/1
  def show
    @food =
      policy_scope(Food)
      .includes(:food_groups)
      .find(params[:id])
  end

  # GET /foods/new
  def new
    @food = Food.new
  end

  # GET /foods/1/edit
  def edit
    @food = policy_scope(Food).includes(:food_groups).find(params[:id])
  end

  # POST /foods
  def create
    @food = Food.new(food_params.merge(user: current_user))

    if @food.save
      respond_to do |format|
        format.html { redirect_to(foods_path) }
        format.turbo_stream
      end
    else
      load_related_models
      render(:new, status: :unprocessable_entity)
    end
  end

  # PATCH/PUT /foods/1
  def update
    @food = policy_scope(Food).find(params[:id])
    if @food.update(food_params)
      respond_to do |format|
        format.html { redirect_to(foods_path) }
        format.turbo_stream
      end
    else
      load_related_models
      render(:edit, status: :unprocessable_entity)
    end
  end

  # DELETE /foods/1
  def destroy
    @food = policy_scope(Food).find(params[:id])
    @food.destroy
    respond_to do |format|
      format.html { redirect_to(foods_path) }
      format.turbo_stream
    end
  end

  private

  def load_related_models
    @food_groups = policy_scope(FoodGroup).all
  end

  def food_params
    params.require(:food).permit(:name, { food_group_ids: [] })
  end
end
