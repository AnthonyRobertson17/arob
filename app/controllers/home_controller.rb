# frozen_string_literal: true

class HomeController < ApplicationController
  def index
    @recent_workouts = Workout.completed.order(completed_at: :desc).limit(5)
  end
end
