# frozen_string_literal: true

module Exercises
  class ReorderController < ApplicationController
    before_action(:set_workout)
    before_action(:set_exercise)

    def move_higher
      return head(:unprocessable_entity) if @exercise.first?

      @other_exercise = @exercise.higher_item
      @exercise.move_higher

      respond_to do |format|
        format.html { redirect_to(workout_path(@workout)) }
        format.turbo_stream
      end
    end

    def move_lower
      return head(:unprocessable_entity) if @exercise.last?

      @other_exercise = @exercise.lower_item
      @exercise.move_lower

      respond_to do |format|
        format.html { redirect_to(workout_path(@workout)) }
        format.turbo_stream
      end
    end

    private

    def set_workout
      @workout = policy_scope(Workout).find(params[:workout_id])
    end

    def set_exercise
      @exercise = @workout.exercises.find(params[:id])
    end
  end
end
