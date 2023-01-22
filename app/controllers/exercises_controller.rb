# frozen_string_literal:true

class ExercisesController < ApplicationController
  before_action(:set_workout)
  before_action(:set_exercise, only: [:edit, :update, :destroy])
  before_action(:set_exercise_types, only: [:new, :edit])

  def new
    @exercise = Exercise.new
  end

  def edit; end

  def create
    @exercise = @workout.exercises.build(exercise_params)

    if @exercise.save
      respond_to do |format|
        format.html { redirect_to(workout_path(@workout)) }
        format.turbo_stream { turbo_create }
      end
    else
      set_exercise_types
      render(:new, status: :unprocessable_entity)
    end
  end

  def update
    if @exercise.update(exercise_params)
      respond_to do |format|
        format.html { redirect_to(workout_path(@workout)) }
        format.turbo_stream
      end
    else
      set_exercise_types
      render(:edit, status: :unprocessable_entity)
    end
  end

  def destroy
    @exercise.destroy

    respond_to do |format|
      format.html { redirect_to(workout_path(@workout)) }
      format.turbo_stream { turbo_delete }
    end
  end

  private

  def turbo_create
    @second_to_last_exercise = @workout.exercises.second_to_last
  end

  def turbo_delete
    @workout.reload
    return unless @workout.exercises.any?

    @first_exercise = @workout.exercises.first
    @last_exercise = @workout.exercises.last
  end

  def set_exercise
    @exercise = @workout.exercises.find(params[:id])
  end

  def exercise_params
    params.require(:exercise).permit(:exercise_type_id, :note)
  end

  def set_workout
    @workout = policy_scope(Workout).find(params[:workout_id])
  end

  def set_exercise_types
    @exercise_types = policy_scope(ExerciseType).all.order("lower(name)")
  end
end
