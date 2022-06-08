# frozen_string_literal: true

require "test_helper"

module Users
  class ProfileControllerTest < ActionDispatch::IntegrationTest
    setup do
      @user = create :user
      sign_in @user
    end

    test "get show" do
      get profile_url
      assert_response :success

      assert_select "p", { text: "Email:\n    #{@user.email}", count: 1 }
    end

    test "get edit" do
      get profile_edit_url
      assert_response :success
    end

    test "update workout" do
      patch "/profile", params: { user: { time_zone: "Eastern Time (US & Canada)" } }
      assert_redirected_to profile_url
      assert_equal "Eastern Time (US & Canada)", @user.reload.time_zone
    end
  end
end
