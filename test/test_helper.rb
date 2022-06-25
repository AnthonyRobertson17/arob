# frozen_string_literal: true

ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"
require "minitest/reporters"

Minitest::Reporters.use!

module ActiveSupport
  class TestCase
    include FactoryBot::Syntax::Methods

    parallelize threshold: 25
  end
end

module ActionDispatch
  class IntegrationTest
    include Devise::Test::IntegrationHelpers
  end
end

module ActionDispatch
  class SystemTestCase
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
