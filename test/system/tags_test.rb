# frozen_string_literal:true

require "application_system_test_case"

class TagsTest < ApplicationSystemTestCase
  test "visiting the index" do
    user = login
    create :exercise_tag, user: user
    create :workout_tag, user: user

    visit tags_url
    assert_selector "h1", text: "Tags"
  end
end
