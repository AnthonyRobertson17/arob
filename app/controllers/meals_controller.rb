# frozen_string_literal:true

class MealsController < ApplicationController
  def index
    @meals = policy_scope(Meal).all
  end

  def show
    @meal = policy_scope(Meal).find(params[:id])
  end

  def new
    @meal = Meal.new
    @meal.date = Time.zone.now
  end

  def edit
    @meal = policy_scope(Meal).find(params[:id])
  end

  def create
    @meal = Meal.new(meal_params.merge(user: current_user))

    if @meal.save
      respond_to do |format|
        format.html { redirect_to(meals_path) }
        format.turbo_stream
      end
    else
      render(:new, status: :unprocessable_entity)
    end
  end

  def update
    @meal = policy_scope(Meal).find(params[:id])
    if @meal.update(meal_params)
      respond_to do |format|
        format.html { redirect_to(meals_path) }
        format.turbo_stream
      end
    else
      render(:edit, status: :unprocessable_entity)
    end
  end

  def destroy
    @meal = policy_scope(Meal).find(params[:id])
    @meal.destroy
    respond_to do |format|
      format.html { redirect_to(meals_path) }
      format.turbo_stream
    end
  end

  private

  def meal_params
    @meal_params ||= params.expect(meal: [:name, :meal_type, :date])
  end
end
