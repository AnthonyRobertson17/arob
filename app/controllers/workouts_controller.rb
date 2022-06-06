# frozen_string_literal: true

class WorkoutsController < ApplicationController
  before_action :set_workout, only: [:show, :edit, :update, :destroy]

  # GET /workouts
  def index
    @workouts = users_workouts.all
  end

  # GET /workouts/1
  def show; end

  # GET /workouts/new
  def new
    @workout = Workout.new
  end

  # GET /workouts/1/edit
  def edit; end

  # POST /workouts
  def create
    @workout = Workout.new(workout_params.merge(user: current_user))

    if @workout.save
      redirect_to @workout, notice: I18n.t("workouts.flash.success.create")
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /workouts/1
  def update
    if @workout.update(workout_params)
      redirect_to @workout, notice: I18n.t("workouts.flash.success.update")
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /workouts/1
  def destroy
    @workout.destroy
    redirect_to workouts_url, notice: I18n.t("workouts.flash.success.destroy")
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_workout
    @workout = users_workouts.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def workout_params
    params.require(:workout).permit([:name, :workout_category_id])
  end

  def users_workouts
    Workout.for_user(current_user)
  end
end
