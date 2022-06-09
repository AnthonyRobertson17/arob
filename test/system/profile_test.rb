# frozen_string_literal:true

require "application_system_test_case"

class HomeTest < ApplicationSystemTestCase
  test "should be able to visit profile" do
    user = login
    visit root_url

    click_on user.email
    assert_text "Profile"
  end

  test "should be able to edit profile" do
    login
    visit profile_url

    click_on "Edit"

    assert_text "Edit Profile"

    select "Eastern Time (US & Canada)", from: "Time zone"
    click_on "Update User"

    assert_text "Profile was successfully updated."
    assert_text "Eastern Time (US & Canada)"
  end
end
