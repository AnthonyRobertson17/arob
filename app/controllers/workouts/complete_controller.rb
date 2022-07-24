# frozen_string_literal: true

module Workouts
  class CompleteController < ApplicationController
    before_action :set_workout
    rescue_from Workout::NotStartedError do
      redirect_to @workout, alert: I18n.t("workouts.flash.error.not_started")
    end
    rescue_from Workout::AlreadyCompletedError do
      redirect_to @workout, alert: I18n.t("workouts.flash.error.already_completed")
    end

    def update
      @workout.complete!
      respond_to do |format|
        format.html { redirect_to(@workout) }
        format.turbo_stream
      end
    end

    private

    def set_workout
      @workout = Workout.find(params.require(:id))
    end
  end
end
