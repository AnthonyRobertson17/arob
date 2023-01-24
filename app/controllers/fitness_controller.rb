# frozen_string_literal: true

class FitnessController < ApplicationController
  def index
    @recent_workouts = policy_scope(Workout).completed.order(completed_at: :desc).limit(5)
    @in_progress_workouts = policy_scope(Workout).in_progress.order(started_at: :desc).limit(5)
  end
end
