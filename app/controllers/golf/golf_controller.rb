# frozen_string_literal: true

module Golf
  class GolfController < ApplicationController
    def index
      sessions = policy_scope(Golf::PuttingSession)
      total_putts = Golf::Putt.joins(:putting_session).where(golf_putting_sessions: { user: current_user }).count
      holed_putts = Golf::Putt.joins(:putting_session).where(golf_putting_sessions: { user: current_user }, holed: true).count

      @putting_stats = {
        sessions: sessions.count,
        total_putts:,
        make_pct: total_putts > 0 ? (holed_putts.to_f / total_putts * 100).round(1) : 0,
      }
    end
  end
end
