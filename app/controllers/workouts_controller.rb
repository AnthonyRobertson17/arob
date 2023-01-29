# frozen_string_literal: true

class WorkoutsController < ApplicationController
  before_action(:set_workout, only: [:edit, :update, :destroy])
  before_action(:set_workout_tags, only: [:new, :edit])

  # GET /workouts
  def index
    @workouts = policy_scope(Workout).order(id: :desc)
  end

  # GET /workouts/1
  def show
    @workout = policy_scope(Workout).includes(exercises: [:exercise_sets, :exercise_type]).find(params[:id])
  end

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
      respond_to do |format|
        format.html { redirect_to(@workout) }
        format.turbo_stream
      end
    else
      set_workout_tags
      render(:edit, status: :unprocessable_entity)
    end
  end

  # DELETE /workouts/1
  def destroy
    @workout.destroy
    redirect_to(workouts_url, status: :see_other)
  end

  private

  def set_workout_tags
    @workout_tags = policy_scope(WorkoutTag).all
  end

  def set_workout
    @workout = policy_scope(Workout).find(params[:id])
  end

  def workout_params
    params.require(:workout).permit([:name, :started_at, :completed_at, { tag_ids: [] }])
  end
end
