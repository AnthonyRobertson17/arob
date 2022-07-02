# frozen_string_literal: true

module Workouts
  class StartController < ApplicationController
    before_action :set_workout
    rescue_from Workout::AlreadyStartedError do
      redirect_to @workout, alert: I18n.t("workouts.flash.error.already_started")
    end

    def update
      @workout.start!
      redirect_to @workout
    end

    private

    def set_workout
      @workout = Workout.find(params.require(:id))
    end
  end
end
