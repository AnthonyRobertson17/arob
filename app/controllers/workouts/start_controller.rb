# frozen_string_literal: true

module Workouts
  class StartController < ApplicationController
    before_action :set_workout

    def update
      @workout.start!
      redirect_to @workout, notice: I18n.t("workout.flash.success.started")
    end

    private

    def set_workout
      @workout = Workout.find(params.require(:id))
    end
  end
end
