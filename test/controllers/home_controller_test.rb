# frozen_string_literal: true

require "test_helper"

class HomeControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    user = create :user
    sign_in user

    get authenticated_root_url
    assert_response :success
  end
end
