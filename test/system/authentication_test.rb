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

  test "should be able to sign up" do
    visit new_user_registration_url

    fill_in "Email", with: "foo@test.test"
    fill_in "Password", with: "password12345"
    fill_in "Password confirmation", with: "password12345"

    click_on "Sign Up"

    assert_text "foo@test.test"
    assert_text "Welcome! You have signed up successfully."
    assert_current_path authenticated_root_path
  end

  test "can visit sign up from login page" do
    visit new_user_session_url

    click_on "Sign up"
    assert_current_path new_user_registration_path
  end
end
