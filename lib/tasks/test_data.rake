# frozen_string_literal: true

namespace :test_data do
  desc "Creates a bunch of test data for local development " \
       "Usage: `rake test_data:create`"
  task create: :environment do
    CreateTestDataCommand.execute
  end
end
