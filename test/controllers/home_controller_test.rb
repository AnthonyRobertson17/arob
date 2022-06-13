# frozen_string_literal: true

require "test_helper"

class HomeControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    user = create :user
    sign_in user

    get authenticated_root_url
    assert_response :success
  end

  test "should only show recent workouts for current user" do
    user = create :user
    sign_in user

    create :workout, :completed, user: user, name: "gucci"
    create :workout, :completed, name: "do not wanna see this"

    get authenticated_root_url

    assert_select "h5", { text: /gucci/, count: 1 }
    assert_select "h5", { text: /do not wanna see this/, count: 0 }
  end
end
