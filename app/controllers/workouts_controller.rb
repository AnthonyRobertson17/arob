# frozen_string_literal: true

class WorkoutsController < ApplicationController
  before_action(:set_workout, only: [:show, :edit, :update, :destroy])
  before_action(:set_workout_tags, only: [:new, :edit])

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
      redirect_to(@workout)
    else
      set_workout_tags
      render(:new, status: :unprocessable_entity)
    end
  end

  # PATCH/PUT /workouts/1
  def update
    if @workout.update(workout_params)
      redirect_to(@workout)
    else
      set_workout_tags
      render(:edit, status: :unprocessable_entity)
    end
  end

  # DELETE /workouts/1
  def destroy
    @workout.destroy
    redirect_to(workouts_url)
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_workout
    @workout = users_workouts.find(params[:id])
  end

  def set_workout_tags
    @workout_tags = WorkoutTag.for_user(current_user).all.order("lower(name)")
  end

  # Only allow a list of trusted parameters through.
  def workout_params
    params.require(:workout).permit([:name, { tag_ids: [] }])
  end

  def users_workouts
    Workout.for_user(current_user)
  end
end
