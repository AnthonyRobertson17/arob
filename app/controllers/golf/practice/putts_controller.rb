# frozen_string_literal: true

module Golf
  module Practice
    class PuttsController < ApplicationController
      before_action :set_putting_session

      def create
        @putt = @putting_session.putts.new(putt_params)

        if @putt.save
          @putts = @putting_session.putts.order(created_at: :desc)
          @next_distance = @putting_session.last_distance
          @new_putt = Golf::Putt.new(distance_feet: @next_distance)
          respond_to do |format|
            format.turbo_stream
            format.html { redirect_to(golf_practice_putting_session_path(@putting_session)) }
          end
        else
          redirect_to(golf_practice_putting_session_path(@putting_session), status: :unprocessable_entity)
        end
      end

      def destroy
        @putt = @putting_session.putts.find(params[:id])
        @putt.destroy
        @putts = @putting_session.putts.order(created_at: :desc)
        respond_to do |format|
          format.turbo_stream
          format.html { redirect_to(golf_practice_putting_session_path(@putting_session)) }
        end
      end

      private

      def set_putting_session
        @putting_session = policy_scope(Golf::PuttingSession).find(params[:putting_session_id])
      end

      def putt_params
        params.expect(golf_putt: [:holed, :pace, :direction, :distance_feet])
      end
    end
  end
end
