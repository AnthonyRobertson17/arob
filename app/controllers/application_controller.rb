# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include Pundit::Authorization

  before_action :authenticate_user!

  around_action :set_time_zone, if: :current_user

  private

  def set_time_zone(&)
    Time.use_zone(current_user.time_zone, &)
  end
end
