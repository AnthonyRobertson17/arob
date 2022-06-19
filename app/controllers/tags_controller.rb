# frozen_string_literal:true

class TagsController < ApplicationController
  # GET /workout_categories
  def index
    @workout_tags = workout_tags.all
    @exercise_tags = exercise_tags.all
  end

  private

  def workout_tags
    WorkoutTag.for_user(current_user)
  end

  def exercise_tags
    ExerciseTag.for_user(current_user)
  end
end
