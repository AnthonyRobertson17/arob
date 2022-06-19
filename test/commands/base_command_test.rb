# frozen_string_literal: true

require "test_helper"

class TestCommand < BaseCommand
  def execute
    "wow such execution"
  end
end

class BaseCommandTest < ActiveSupport::TestCase
  test "allows for execution of the command through the execute class method" do
    assert_equal "wow such execution", TestCommand.execute
  end
end
