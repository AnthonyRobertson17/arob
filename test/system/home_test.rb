# frozen_string_literal:true

require "application_system_test_case"

class HomeTest < ApplicationSystemTestCase
  test "should only see completed workouts" do
    user = login
    create :workout, user:, name: "nah dog"
    create :workout, :started, user:, name: "nope"
    create :workout, :completed, user:, name: "oh yeah"

    visit root_url

    assert_text "oh yeah"
    assert_no_text "nah dog"
    assert_no_text "nope"
  end
end
