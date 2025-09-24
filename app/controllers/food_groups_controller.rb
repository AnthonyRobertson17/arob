# frozen_string_literal: true

class FoodGroupsController < ApplicationController
  def index
    @food_groups = policy_scope(FoodGroup).all
  end

  def show
    @food_group = policy_scope(FoodGroup).find(params[:id])
  end

  def new
    @food_group = FoodGroup.new
  end

  def edit
    @food_group = policy_scope(FoodGroup).find(params[:id])
  end

  def create
    @food_group = FoodGroup.new(food_group_params.merge(user: current_user))

    if @food_group.save
      respond_to do |format|
        format.html { redirect_to(food_groups_path) }
        format.turbo_stream
      end
    else
      render(:new, status: :unprocessable_entity)
    end
  end

  def update
    @food_group = policy_scope(FoodGroup).find(params[:id])
    if @food_group.update(food_group_params)
      respond_to do |format|
        format.html { redirect_to(food_groups_path) }
        format.turbo_stream
      end
    else
      render(:edit, status: :unprocessable_entity)
    end
  end

  def destroy
    @food_group = policy_scope(FoodGroup).find(params[:id])
    @food_group.destroy
    respond_to do |format|
      format.html { redirect_to(food_groups_path) }
      format.turbo_stream
    end
  end

  private

  def food_group_params
    params.expect(food_group: [:name, :emoji, { food_ids: [] }])
  end
end
