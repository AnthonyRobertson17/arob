# frozen_string_literal:true

class ExerciseSetsController < ApplicationController
  before_action :set_workout
  before_action :set_exercise
  before_action :set_exercise_set, only: [:edit, :update, :destroy]

  def new
    @exercise_set = ExerciseSet.new
  end

  def edit; end

  def create
    @exercise_set = @exercise.exercise_sets.build(exercise_set_params)

    if @exercise_set.save
      respond_to do |format|
        format.html { redirect_to(@workout) }
        format.turbo_stream
      end
    else
      render(:new, status: :unprocessable_entity)
    end
  end

  def update
    if @exercise_set.update(exercise_set_params)
      respond_to do |format|
        format.html { redirect_to(@workout) }
        format.turbo_stream
      end
    else
      render(:edit, status: :unprocessable_entity)
    end
  end

  def destroy
    @exercise_set.destroy

    respond_to do |format|
      format.html { redirect_to(@workout) }
      format.turbo_stream
    end
  end

  private

  def set_workout
    @workout = policy_scope(Workout).find(params[:workout_id])
  end

  def set_exercise
    @exercise = @workout.exercises.find(params[:exercise_id])
  end

  def set_exercise_set
    @exercise_set = @exercise.exercise_sets.find(params[:id])
  end

  def exercise_set_params
    params.require(:exercise_set).permit(:weight, :repetitions)
  end
end
