# frozen_string_literal: true

module Golf
  module Practice
    module PuttingSessions
      class CompleteController < ApplicationController
        before_action :set_putting_session

        rescue_from Golf::PuttingSession::AlreadyCompletedError do
          redirect_to(golf_practice_putting_session_path(@putting_session),
            alert: t("golf.putting_sessions.flash.error.already_completed"))
        end

        def update
          @putting_session.complete!
          redirect_to(golf_practice_putting_session_path(@putting_session))
        end

        private

        def set_putting_session
          @putting_session = policy_scope(Golf::PuttingSession).find(params[:id])
        end
      end
    end
  end
end
