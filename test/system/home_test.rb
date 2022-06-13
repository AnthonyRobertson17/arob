# frozen_string_literal:true

require "application_system_test_case"

class HomeTest < ApplicationSystemTestCase
  test "should only see completed and in progress workouts" do
    user = login
    create :workout, user:, name: "nah dog"
    create :workout, :started, user:, name: "yee"
    create :workout, :completed, user:, name: "oh yeah"

    visit root_url

    assert_text "oh yeah"
    assert_text "yee"
    assert_no_text "nah dog"
  end
end
