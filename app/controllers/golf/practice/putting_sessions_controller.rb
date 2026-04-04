# frozen_string_literal: true

module Golf
  module Practice
    class PuttingSessionsController < ApplicationController
      before_action :set_putting_session, only: [:show, :destroy]

      def index
        @putting_sessions = policy_scope(Golf::PuttingSession).order(id: :desc)
      end

      def stats
        sessions = policy_scope(Golf::PuttingSession).completed.includes(:putts).order(completed_at: :asc)
        all_putts = Golf::Putt.joins(:putting_session).where(golf_putting_sessions: { user: current_user })

        @total_sessions   = sessions.count
        @total_putts      = all_putts.count
        @overall_make_pct = make_pct(all_putts.where(holed: true).count, @total_putts)

        # By session type
        @by_type = Golf::PuttingSession.session_types.keys.filter_map do |type|
          type_putts = all_putts.joins(:putting_session).where(golf_putting_sessions: { session_type: type })
          next if type_putts.empty?

          { label: type.humanize, pct: make_pct(type_putts.where(holed: true).count, type_putts.count), count: type_putts.count }
        end

        # By distance (only distances with 3+ putts)
        @by_distance = all_putts.where.not(distance_feet: nil)
                                .group(:distance_feet)
                                .having("count(*) >= 3")
                                .order(:distance_feet)
                                .pluck(:distance_feet, Arel.sql("count(*) as total"), Arel.sql("sum(case when holed then 1 else 0 end) as made"))
                                .map { |dist, total, made| { dist:, total:, pct: make_pct(made, total) } }

        # Miss breakdown
        misses = all_putts.where(holed: false)
        miss_total = misses.count
        @miss_direction = misses.group(:direction).count
                                .transform_keys { |k| Golf::Putt.human_attribute_name("directions.#{k}") }
                                .transform_values { |v| { count: v, pct: make_pct(v, miss_total) } }
        @miss_pace = misses.where.not(pace: nil).group(:pace).count
                           .transform_keys { |k| Golf::Putt.human_attribute_name("paces.#{k}") }
                           .transform_values { |v| { count: v, pct: make_pct(v, miss_total) } }

        # Session trend (all completed sessions in chronological order)
        @session_trend = sessions.map do |s|
          { date: s.started_at.to_date, type: s.session_type.humanize, count: s.putts.size, pct: s.make_percentage || 0 }
        end

        # Chart configs
        if @session_trend.size >= 2
          @trend_chart_config = {
            type: "line",
            data: {
              labels: @session_trend.map { |s| s[:date].strftime("%-d %b") },
              datasets: [{
                label: "Make %",
                data: @session_trend.map { |s| s[:pct] },
                borderColor: "#198754",
                backgroundColor: "rgba(25,135,84,0.1)",
                fill: true,
                tension: 0.4,
                pointRadius: 5,
                pointBackgroundColor: "#198754"
              }]
            },
            options: {
              scales: { y: { min: 0, max: 100 } },
              plugins: { legend: { display: false } }
            }
          }
        end

        unless @by_distance.empty?
          dist_colors = @by_distance.map { |r| r[:pct] >= 70 ? "rgba(25,135,84,0.8)" : r[:pct] >= 40 ? "rgba(255,193,7,0.8)" : "rgba(220,53,69,0.8)" }
          @dist_chart_config = {
            type: "bar",
            data: {
              labels: @by_distance.map { |r| "#{r[:dist]} ft" },
              datasets: [{
                label: "Make %",
                data: @by_distance.map { |r| r[:pct] },
                backgroundColor: dist_colors,
                borderRadius: 6
              }]
            },
            options: {
              scales: { y: { min: 0, max: 100 } },
              plugins: { legend: { display: false } }
            }
          }
        end

        unless @by_type.empty?
          @type_chart_config = {
            type: "doughnut",
            data: {
              labels: @by_type.map { |r| "#{r[:label]} #{r[:pct]}%" },
              datasets: [{
                data: @by_type.map { |r| r[:count] },
                backgroundColor: ["rgba(13,110,253,0.8)", "rgba(25,135,84,0.8)"],
                borderWidth: 2
              }]
            },
            options: { plugins: { legend: { position: "bottom" } }, cutout: "60%" }
          }
        end

        unless @miss_direction.empty?
          @dir_chart_config = {
            type: "doughnut",
            data: {
              labels: @miss_direction.map { |label, d| "#{label} #{d[:pct]}%" },
              datasets: [{
                data: @miss_direction.map { |_, d| d[:count] },
                backgroundColor: ["rgba(220,53,69,0.8)", "rgba(108,117,125,0.8)", "rgba(255,193,7,0.8)"],
                borderWidth: 2
              }]
            },
            options: { plugins: { legend: { position: "bottom" } }, cutout: "60%" }
          }
        end

        unless @miss_pace.empty?
          @pace_chart_config = {
            type: "doughnut",
            data: {
              labels: @miss_pace.map { |label, d| "#{label} #{d[:pct]}%" },
              datasets: [{
                data: @miss_pace.map { |_, d| d[:count] },
                backgroundColor: ["rgba(13,202,240,0.8)", "rgba(253,126,20,0.8)", "rgba(108,117,125,0.8)"],
                borderWidth: 2
              }]
            },
            options: { plugins: { legend: { position: "bottom" } }, cutout: "60%" }
          }
        end
      end

      def show
        @putts = @putting_session.putts.order(created_at: :desc)
        @next_distance = @putting_session.last_distance
        @new_putt = Golf::Putt.new(distance_feet: @next_distance)
      end

      def new
        @putting_session = Golf::PuttingSession.new
      end

      def create
        @putting_session = Golf::PuttingSession.new(
          putting_session_params.merge(user: current_user, started_at: Time.current)
        )

        if @putting_session.save
          redirect_to(golf_practice_putting_session_path(@putting_session))
        else
          render(:new, status: :unprocessable_entity)
        end
      end

      def destroy
        @putting_session.destroy
        redirect_to(golf_practice_putting_sessions_path, status: :see_other)
      end

      private

      def make_pct(made, total)
        return 0 if total.zero?

        (made.to_f / total * 100).round(1)
      end

      def set_putting_session
        @putting_session = policy_scope(Golf::PuttingSession).find(params[:id])
      end

      def putting_session_params
        params.expect(golf_putting_session: [:session_type])
      end
    end
  end
end
