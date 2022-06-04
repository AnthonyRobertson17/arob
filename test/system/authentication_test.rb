# frozen_string_literal:true

require "application_system_test_case"

class AuthenticationTest < ApplicationSystemTestCase
  setup do
    @user = create :user
  end

  test "should be able to login" do
    login email: @user.email

    assert_text @user.email
    assert_text "Signed in successfully."
    assert_current_path authenticated_root_path
  end

  test "should be able to logout" do
    login email: @user.email

    click_on "Logout"
    assert_text "Signed out successfully."
    assert_current_path new_user_session_path
  end

  test "can not visit sign up from login page" do
    visit new_user_session_url

    assert_no_text "Sign Up"
  end
end
