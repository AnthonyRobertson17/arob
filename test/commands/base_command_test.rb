# frozen_string_literal: true

require "test_helper"

class TestCommand < BaseCommand
  def execute
    "wow such execution"
  end
end

class BaseCommandTest < ActiveSupport::TestCase
  test "allows for execution of the command through the execute class method" do
    response = TestCommand.execute

    assert_equal("wow such execution", response)
  end
end
