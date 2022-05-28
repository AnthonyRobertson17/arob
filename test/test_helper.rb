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
    include Warden::Test::Helpers
    def login(email:, password: "password12345")
      visit new_user_session_url

      fill_in "Email", with: email
      fill_in "Password", with: password

      click_on "Log in"
    end
  end
end
