# frozen_string_literal: true

module Users
  class ProfileController < ApplicationController
    # GET /profile
    def show; end

    # GET /profile/edit
    def edit; end

    # PATCH /profile
    def update
      if current_user.update(user_params)
        redirect_to(profile_url)
      else
        render(:edit, status: :unprocessable_entity)
      end
    end

    private

    # Only allow a list of trusted parameters through.
    def user_params
      params.expect(user: [:time_zone])
    end
  end
end
