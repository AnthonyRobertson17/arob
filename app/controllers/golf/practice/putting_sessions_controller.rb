# frozen_string_literal: true

module Golf
  module Practice
    class PuttingSessionsController < ApplicationController
      before_action :set_putting_session, only: [:show, :destroy]

      MAT_BUCKETS = [
        { key: "short", label: "Short (1–5 ft)", range: 1..5 },
        { key: "mid",   label: "Mid (6–9 ft)",   range: 6..9 },
      ].freeze

      GREEN_BUCKETS = [
        { key: "short", label: "Short (1–5 ft)",  range: 1..5 },
        { key: "mid",   label: "Mid (6–15 ft)",   range: 6..15 },
        { key: "long",  label: "Long (16+ ft)",   range: 16.. },
      ].freeze

      BUCKET_COLORS = { "short" => "#198754", "mid" => "#0d6efd", "long" => "#fd7e14" }.freeze
      FOOT_COLORS   = ["#198754", "#0d6efd", "#fd7e14", "#dc3545", "#6f42c1", "#20c997", "#ffc107", "#0dcaf0",
                       "#d63384",].freeze

      def index
        @putting_sessions = policy_scope(Golf::PuttingSession).order(id: :desc)
      end

      def stats
        @active_tab    = params[:tab].presence_in(Golf::PuttingSession.session_types.keys) || "putting_mat"
        @buckets       = @active_tab == "putting_mat" ? MAT_BUCKETS : GREEN_BUCKETS
        @distance_view = params[:distance_view].presence_in(["buckets", "feet"]) || "buckets"

        sessions = policy_scope(Golf::PuttingSession)
                   .completed
                   .where(session_type: @active_tab)
                   .includes(:putts)
                   .order(completed_at: :asc)

        all_user_putts = Golf::Putt.joins(:putting_session)
                                   .where(golf_putting_sessions: { user: current_user })
        tab_putts = all_user_putts.where(golf_putting_sessions: { session_type: @active_tab })

        @total_sessions   = sessions.count
        @total_putts      = tab_putts.count
        @overall_make_pct = make_pct(tab_putts.where(holed: true).count, @total_putts)

        # Scoring range emphasis (1–8 ft)
        scoring_putts  = tab_putts.where(distance_feet: 1..8)
        @scoring_range = {
          count: scoring_putts.count,
          pct: make_pct(scoring_putts.where(holed: true).count, scoring_putts.count),
        }

        # Performance by distance bucket
        @bucket_stats = @buckets.map { |b| calc_bucket_stats(tab_putts, b) }

        # Miss patterns per bucket
        @miss_by_bucket = @buckets.map { |b| calc_miss_by_bucket(tab_putts, b) }

        # Miss consistency across all distances
        misses                 = tab_putts.where(holed: false)
        @direction_consistency = miss_consistency(misses.where.not(direction: nil).group(:direction).count, "direction")
        @pace_consistency      = miss_consistency(misses.where.not(pace: nil).group(:pace).count, "pace")

        # Practice distribution vs performance
        total_bucketed               = @bucket_stats.sum { |bs| bs[:total] }
        @distribution_vs_performance = @bucket_stats.map do |bs|
          {
            label: bs[:label],
            practice_pct: total_bucketed.positive? ? (bs[:total].to_f / total_bucketed * 100).round(1) : 0,
            make_pct: bs[:pct],
            total: bs[:total],
          }
        end

        # Session trend (chronological, includes per-bucket and optionally per-foot make %)
        @session_trend = sessions.map do |s|
          s_putts = s.putts.to_a
          bpcts   = @buckets.map do |b|
            b_putts = s_putts.select { |p| p.distance_feet && b[:range].cover?(p.distance_feet) }
            pct     = b_putts.any? ? make_pct(b_putts.count(&:holed), b_putts.size) : nil
            { key: b[:key], label: b[:label], pct: }
          end
          foot_pcts = if @distance_view == "feet"
                        s_putts.select(&:distance_feet)
                               .group_by(&:distance_feet)
                               .transform_values { |fps| make_pct(fps.count(&:holed), fps.size) }
                      end
          { date: s.started_at.to_date, count: s_putts.size, pct: s.make_percentage || 0,
            bucket_pcts: bpcts, foot_pcts:, }
        end

        # Personal bests
        if @session_trend.any?
          @best_session   = @session_trend.max_by { |s| s[:pct] }
          @current_streak = streak_count(@session_trend.reverse, 60)
          @longest_streak = longest_streak_count(@session_trend, 60)
          @best_by_bucket = @buckets.map do |b|
            best_pct = @session_trend.filter_map do |s|
              bp = s[:bucket_pcts].find { |x| x[:key] == b[:key] }
              bp[:pct] if bp&.fetch(:pct)
            end.max
            { key: b[:key], label: b[:label], best_pct: }
          end
        end

        # Practice frequency
        if @session_trend.size >= 2
          dates                   = sessions.pluck(:completed_at)
          gaps                    = dates.each_cons(2).map { |a, b| ((b - a) / 1.day).round }
          @avg_days_between       = (gaps.sum.to_f / gaps.size).round(1)
          @sessions_last_28_days  = sessions.where(completed_at: 28.days.ago..).count
        end

        # Volume vs performance
        @volume_vs_performance = @session_trend.map { |s| { volume: s[:count], pct: s[:pct] } }

        # Per-foot stats (only computed when in foot view)
        if @distance_view == "feet"
          @foot_stats   = compute_foot_stats(tab_putts)
          @miss_by_foot = compute_miss_by_foot(tab_putts)
        end

        # Cross-tab comparison
        @cross_tab = build_cross_tab(all_user_putts)

        build_chart_configs
      end

      def show
        @putts          = @putting_session.putts.order(created_at: :desc)
        @next_distance  = @putting_session.last_distance
        @new_putt       = Golf::Putt.new(distance_feet: @next_distance)
      end

      def new
        @putting_session = Golf::PuttingSession.new
      end

      def create
        @putting_session = Golf::PuttingSession.new(
          putting_session_params.merge(user: current_user, started_at: Time.current),
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

      def calc_bucket_stats(putts, bucket)
        bp    = putts.where(distance_feet: bucket[:range])
        total = bp.count
        made  = bp.where(holed: true).count
        { key: bucket[:key], label: bucket[:label], total:, made:, pct: make_pct(made, total) }
      end

      def calc_miss_by_bucket(putts, bucket)
        misses     = putts.where(holed: false, distance_feet: bucket[:range])
        miss_total = misses.count

        dir = misses.where.not(direction: nil).group(:direction).count
                    .transform_keys { |k| Golf::Putt.human_attribute_name("directions.#{k}") }
                    .transform_values { |v| { count: v, pct: make_pct(v, miss_total) } }

        pace = misses.where.not(pace: nil).group(:pace).count
                     .transform_keys { |k| Golf::Putt.human_attribute_name("paces.#{k}") }
                     .transform_values { |v| { count: v, pct: make_pct(v, miss_total) } }

        { key: bucket[:key], label: bucket[:label], direction: dir, pace:, miss_total: }
      end

      def miss_consistency(counts, type)
        return nil if counts.empty? || counts.values.sum < 5

        total                    = counts.values.sum
        dominant_key, dom_count  = counts.max_by { |_, v| v }
        pct                      = (dom_count.to_f / total * 100).round

        if pct >= 70
          direction_labels = { "left" => "left", "right" => "right", "on_target" => "on-target" }
          pace_labels      = { "too_hard" => "too hard", "too_soft" => "too soft", "perfect" => "perfect pace" }
          labels           = type == "direction" ? direction_labels : pace_labels
          label            = labels.fetch(dominant_key.to_s, dominant_key.to_s.humanize.downcase)
          { systematic: true, dominant: dominant_key, pct:,
            message: "Systematic #{label} miss (#{pct}% of misses) — likely a mechanical issue", }
        else
          { systematic: false, pct:, message: "Mixed miss pattern — no single dominant direction" }
        end
      end

      def rolling_average(values, window = 5)
        values.each_with_index.map do |_, i|
          slice = values[[0, i - window + 1].max..i]
          (slice.sum.to_f / slice.size).round(1)
        end
      end

      def streak_count(sessions_reversed, threshold)
        sessions_reversed.inject(0) { |count, s| s[:pct] >= threshold ? count + 1 : (break count) }
      end

      def longest_streak_count(sessions, threshold)
        current = max = 0
        sessions.each do |s|
          if s[:pct] >= threshold
            current += 1
            max = current if current > max
          else
            current = 0
          end
        end
        max
      end

      def build_cross_tab(all_user_putts)
        mat_putts   = all_user_putts.where(golf_putting_sessions: { session_type: "putting_mat" },
                                           distance_feet: 1..9,)
        green_putts = all_user_putts.where(golf_putting_sessions: { session_type: "practice_green" },
                                           distance_feet: 1..9,)
        mat_n   = mat_putts.count
        green_n = green_putts.count

        return { has_data: false } if mat_n.zero? || green_n.zero?

        overlap_buckets = [
          { key: "short", label: "Short (1–5 ft)", range: 1..5 },
          { key: "mid",   label: "Mid (6–9 ft)",   range: 6..9 },
        ]

        per_bucket = overlap_buckets.map do |b|
          m = mat_putts.where(distance_feet: b[:range])
          g = green_putts.where(distance_feet: b[:range])
          { label: b[:label], mat_pct: make_pct(m.where(holed: true).count, m.count),
            green_pct: make_pct(g.where(holed: true).count, g.count), mat_n: m.count, green_n: g.count, }
        end

        { has_data: true,
          mat_pct: make_pct(mat_putts.where(holed: true).count, mat_n),
          green_pct: make_pct(green_putts.where(holed: true).count, green_n),
          mat_n:, green_n:, per_bucket:, }
      end

      def build_chart_configs
        return if @session_trend.size < 2

        labels = @session_trend.map { |s| s[:date].strftime("%-d %b") }

        trend_datasets = if @distance_view == "buckets"
                           @buckets.map do |b|
                             pcts = @session_trend.map do |s|
                               s[:bucket_pcts].find do |bp|
                                 bp[:key] == b[:key]
                               end&.dig(:pct)
                             end
                             { label: b[:label], data: pcts, borderColor: BUCKET_COLORS[b[:key]],
                               backgroundColor: "rgba(0,0,0,0)", tension: 0.4, pointRadius: 3, spanGaps: true, }
                           end
                         else
                           all_feet = @session_trend.flat_map { |s| s[:foot_pcts]&.keys || [] }.uniq.sort
                           all_feet.each_with_index.map do |dist, i|
                             color = FOOT_COLORS[i % FOOT_COLORS.size]
                             pcts  = @session_trend.map { |s| s[:foot_pcts]&.[](dist) }
                             { label: "#{dist} ft", data: pcts, borderColor: color,
                               backgroundColor: "rgba(0,0,0,0)", tension: 0.4, pointRadius: 3, spanGaps: true, }
                           end
                         end

        if trend_datasets.any? { |ds| ds[:data].any? }
          @trend_chart_config = {
            type: "line",
            data: { labels:, datasets: trend_datasets },
            options: {
              scales: { y: { min: 0, max: 100 } },
              plugins: { legend: { display: true, position: "bottom" } },
            },
          }
        end

        if @distance_view == "feet" && @foot_stats&.any?
          foot_colors = @foot_stats.map do |r|
            if r[:pct] >= 70
              "rgba(25,135,84,0.8)"
            else
              r[:pct] >= 40 ? "rgba(255,193,7,0.8)" : "rgba(220,53,69,0.8)"
            end
          end
          @foot_make_chart_config = {
            type: "bar",
            data: {
              labels: @foot_stats.map { |r| "#{r[:dist]} ft" },
              datasets: [{ label: "Make %", data: @foot_stats.pluck(:pct),
                           backgroundColor: foot_colors, borderRadius: 6, }],
            },
            options: {
              scales: { y: { min: 0, max: 100 } },
              plugins: { legend: { display: false } },
            },
          }
        end

        if @distribution_vs_performance.any? { |d| d[:total].positive? }
          @distribution_chart_config = {
            type: "bar",
            data: {
              labels: @distribution_vs_performance.pluck(:label),
              datasets: [
                { label: "% of practice", data: @distribution_vs_performance.pluck(:practice_pct),
                  backgroundColor: "rgba(13,110,253,0.6)", borderRadius: 4, },
                { label: "Make %", data: @distribution_vs_performance.pluck(:make_pct),
                  backgroundColor: "rgba(25,135,84,0.6)", borderRadius: 4, },
              ],
            },
            options: {
              scales: { y: { min: 0, max: 100 } },
              plugins: { legend: { display: true, position: "bottom" } },
            },
          }
        end

        if @volume_vs_performance.size >= 3
          @volume_chart_config = {
            type: "scatter",
            data: {
              datasets: [{
                label: "Sessions",
                data: @volume_vs_performance.map { |v| { x: v[:volume], y: v[:pct] } },
                backgroundColor: "rgba(25,135,84,0.6)",
                pointRadius: 5,
              }],
            },
            options: {
              scales: {
                x: { title: { display: true, text: "Putts in session" } },
                y: { min: 0, max: 100, title: { display: true, text: "Make %" } },
              },
              plugins: { legend: { display: false } },
            },
          }
        end

        return unless @cross_tab[:has_data]

        @cross_tab_chart_config = {
          type: "bar",
          data: {
            labels: @cross_tab[:per_bucket].pluck(:label),
            datasets: [
              { label: "Mat make %", data: @cross_tab[:per_bucket].pluck(:mat_pct),
                backgroundColor: "rgba(13,110,253,0.6)", borderRadius: 4, },
              { label: "Green make %", data: @cross_tab[:per_bucket].pluck(:green_pct),
                backgroundColor: "rgba(25,135,84,0.6)", borderRadius: 4, },
            ],
          },
          options: {
            scales: { y: { min: 0, max: 100 } },
            plugins: { legend: { display: true, position: "bottom" } },
          },
        }
      end

      def compute_foot_stats(putts)
        putts.where.not(distance_feet: nil)
             .group(:distance_feet)
             .order(:distance_feet)
             .pluck(
               :distance_feet,
               Arel.sql("count(*) as total"),
               Arel.sql("sum(case when holed then 1 else 0 end) as made"),
             )
             .map { |dist, total, made| { dist:, total:, made:, pct: make_pct(made, total) } }
      end

      def compute_miss_by_foot(putts)
        misses        = putts.where(holed: false).where.not(distance_feet: nil)
        total_by_foot = misses.group(:distance_feet).count
        dir_by_foot   = misses.where.not(direction: nil).group(:distance_feet, :direction).count
        pace_by_foot  = misses.where.not(pace: nil).group(:distance_feet, :pace).count

        total_by_foot.sort_by { |dist, _| dist }.map do |dist, miss_total|
          { dist:, miss_total:,
            dominant_dir: dominant_miss(dir_by_foot, dist, miss_total, "direction"),
            dominant_pace: dominant_miss(pace_by_foot, dist, miss_total, "pace"), }
        end
      end

      def dominant_miss(counts_by_foot, dist, miss_total, type)
        relevant = counts_by_foot.select { |k, _| k[0] == dist }
        return nil if relevant.empty?

        key_pair, count = relevant.max_by { |_, v| v }
        attr_key        = key_pair[1]
        label           = Golf::Putt.human_attribute_name("#{type.pluralize}.#{attr_key}")
        { label:, pct: make_pct(count, miss_total) }
      end

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
