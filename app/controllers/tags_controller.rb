# frozen_string_literal:true

class TagsController < ApplicationController
  # GET /tags
  def index
    @workout_tags = workout_tags.all
    @exercise_type_tags = exercise_type_tags.all
  end

  private

  def workout_tags
    WorkoutTag.for_user(current_user)
  end

  def exercise_type_tags
    ExerciseTypeTag.for_user(current_user)
  end
end
