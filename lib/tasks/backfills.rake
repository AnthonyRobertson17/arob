# frozen_string_literal: true

namespace :backfills do
  desc "Backfills all the positions for the existing exercises" \
       "Usage: `rake backfills:exercise_positions`"
  task exercise_positions: :environment do
    BackfillExercisePositionsCommand.execute
  end
end
