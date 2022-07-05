# frozen_string_literal:true

class ExercisesController < ApplicationController
  before_action :set_workout
  before_action :set_exercise, only: [:edit, :update, :destroy]
  before_action :set_exercise_types, only: [:new, :edit]

  def new
    @exercise = Exercise.new
  end

  def create
    @exercise = @workout.exercises.build(exercise_params)

    if @exercise.save
      respond_to do |format|
        format.html { redirect_to workout_path(@workout) }
        format.turbo_stream
      end
    else
      set_exercise_types
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @exercise.update(exercise_params)
      respond_to do |format|
        format.html { redirect_to workout_path(@workout) }
        format.turbo_stream
      end
    else
      set_exercise_types
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @exercise.destroy

    respond_to do |format|
      format.html { redirect_to workout_path(@workout) }
      format.turbo_stream
    end
  end

  private

  def set_exercise
    @exercise = @workout.exercises.find(params[:id])
  end

  def exercise_params
    params.require(:exercise).permit(:exercise_type_id)
  end

  def set_workout
    @workout = current_user.workouts.find(params[:workout_id])
  end

  def set_exercise_types
    @exercise_types = current_user.exercise_types.all
  end
end