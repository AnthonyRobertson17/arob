# frozen_string_literal:true

class WorkoutCategoriesController < ApplicationController
  before_action :set_workout_category, only: [:show, :edit, :update, :destroy]

  # GET /workout_categories
  def index
    @workout_categories = workout_categories.all
  end

  # GET /workout_categories/1
  def show; end

  # GET /workout_categories/new
  def new
    @workout_category = WorkoutCategory.new
  end

  # GET /workout_categories/1/edit
  def edit; end

  # POST /workout_categories
  def create
    @workout_category = WorkoutCategory.new(workout_category_params.merge({ user: current_user }))

    if @workout_category.save
      redirect_to @workout_category, notice: I18n.t("workout_categories.flash.success.create")
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /workout_categories/1
  def update
    if @workout_category.update(workout_category_params)
      redirect_to @workout_category, notice: I18n.t("workout_categories.flash.success.update")
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /workout_categories/1
  def destroy
    @workout_category.destroy
    redirect_to workout_categories_url, notice: I18n.t("workout_categories.flash.success.destroy")
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_workout_category
    @workout_category = workout_categories.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def workout_category_params
    params.require(:workout_category).permit(:name)
  end

  def workout_categories
    WorkoutCategory.for_user(current_user)
  end
end
