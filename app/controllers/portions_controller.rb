# frozen_string_literal:true

class PortionsController < ApplicationController
  before_action(:set_meal)
  before_action(:set_portion, only: [:edit, :update, :destroy])

  def new
    @portion = Portion.new
  end

  def edit; end

  def create
    @portion = @meal.portions.new(portion_params.merge(user: current_user))

    if @portion.save
      respond_to do |format|
        format.html { redirect_to(portions_path) }
        format.turbo_stream
      end
    else
      render(:new, status: :unprocessable_entity)
    end
  end

  def update
    if @portion.update(portion_params)
      respond_to do |format|
        format.html { redirect_to(portions_path) }
        format.turbo_stream
      end
    else
      render(:edit, status: :unprocessable_entity)
    end
  end

  def destroy
    @portion.destroy
    respond_to do |format|
      format.html { redirect_to(portions_path) }
      format.turbo_stream
    end
  end

  private

  def portion_params
    params.expect(portion: [:food_id, :food_group_id, :serving_quantity])
  end

  def set_portion
    @portion = @meal.portions.find(params[:id])
  end

  def set_meal
    @meal = policy_scope(Meal).find(params[:meal_id])
  end
end
