# frozen_string_literal: true

class ExerciseCategoriesController < ApplicationController
  before_action :set_exercise_category, only: [:show, :edit, :update, :destroy]

  # GET /exercise_categories
  def index
    @exercise_categories = exercise_categories.all
  end

  # GET /exercise_categories/1
  def show; end

  # GET /exercise_categories/new
  def new
    @exercise_category = ExerciseCategory.new
  end

  # GET /exercise_categories/1/edit
  def edit; end

  # POST /exercise_categories
  def create
    @exercise_category = ExerciseCategory.new(exercise_category_params.merge({ user: current_user }))

    if @exercise_category.save
      redirect_to @exercise_category, notice: I18n.t("exercise_categories.flash.success.create")
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /exercise_categories/1
  def update
    if @exercise_category.update(exercise_category_params)
      redirect_to @exercise_category, notice: I18n.t("exercise_categories.flash.success.update")
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /exercise_categories/1
  def destroy
    @exercise_category.destroy
    redirect_to exercise_categories_url, notice: I18n.t("exercise_categories.flash.success.destroy")
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_exercise_category
    @exercise_category = exercise_categories.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def exercise_category_params
    params.require(:exercise_category).permit(:name)
  end

  def exercise_categories
    ExerciseCategory.for_user(current_user)
  end
end
