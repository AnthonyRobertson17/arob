# frozen_string_literal: true

module Exercises
  class SwapPositionController < ApplicationController
    before_action(:set_workout)
    before_action(:set_exercise)
    before_action(:set_other_exercise)

    def update
      Exercise.transaction do
        swap_positions(@exercise, @other_exercise)
      end

      respond_to do |format|
        format.html { redirect_to(workout_path(@workout)) }
        format.turbo_stream
      end
    end

    private

    def swap_positions(exercise1, exercise2)
      temp1 = exercise1.position
      temp2 = exercise2.position
      exercise1.update!(position: 999_999_999)
      exercise2.update!(position: temp1)
      exercise1.update!(position: temp2)
    end

    def set_workout
      @workout = current_user.workouts.find(params[:workout_id])
    end

    def set_exercise
      @exercise = @workout.exercises.find(params[:id])
    end

    def set_other_exercise
      position = params.require(:position)
      @other_exercise = @workout.exercises.find_by!(position:)
    end
  end
end
