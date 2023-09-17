# frozen_string_literal: true

class NutritionController < ApplicationController
  def index
    @datetime = DateTime.parse(params[:date]) if params[:date].present?
    @datetime ||= DateTime.now

    @meals = policy_scope(Meal).where(date: @datetime.all_day)
  end
end
