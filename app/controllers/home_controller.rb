# frozen_string_literal: true

class HomeController < ApplicationController
  def index
    @recent_workouts = Workout.for_user(current_user).completed.order(completed_at: :desc).limit(5)
    @in_progress_workouts = Workout.for_user(current_user).in_progress.order(started_at: :desc).limit(5)
  end
end
