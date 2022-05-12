# frozen_string_literal:true

require "application_system_test_case"

class HomeTest < ApplicationSystemTestCase
  setup do
    create :workout, name: "nah dog"
    create :workout, :started, name: "nope"
    create :workout, :completed, name: "oh yeah"
  end

  test "should only see completed workouts" do
    visit root_url

    assert_text "oh yeah"
    assert_no_text "nah dog"
    assert_no_text "nope"
  end
end
