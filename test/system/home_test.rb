# frozen_string_literal:true

require "application_system_test_case"

class HomeTest < ApplicationSystemTestCase
  test "should see buttons to go to different app sections" do
    login
    visit(root_url)
    assert_text("Gym")
  end
end
