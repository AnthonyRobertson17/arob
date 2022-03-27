# frozen_string_literal: true

# lib/tasks/factory_bot.rake
namespace :factory_bot do
  desc "Verify that all FactoryBot factories are valid"
  task lint: :environment do
    raise "Error: Not running in test environment" unless Rails.env.test?

    conn = ActiveRecord::Base.connection
    conn.transaction do
      FactoryBot.lint
      raise ActiveRecord::Rollback
    end
  end
end
