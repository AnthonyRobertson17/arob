# frozen_string_literal: true

ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"

module ActiveSupport
  class TestCase
    include FactoryBot::Syntax::Methods
    # Run tests in parallel with specified workers
    parallelize(workers: :number_of_processors)
  end
end

module ActionDispatch
  class IntegrationTest
    include Devise::Test::IntegrationHelpers
  end
end

module ActionDispatch
  class SystemTestCase
    parallelize threshold: 4

    def login(user: nil)
      user ||= create :user, password: "password12345"
      visit new_user_session_url

      fill_in "Email", with: user.email
      fill_in "Password", with: "password12345"

      click_on "Log In"
      user
    end
  end
end
