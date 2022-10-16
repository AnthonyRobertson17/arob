# frozen_string_literal: true

require "test_helper"

class GymControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    user = create(:user)
    sign_in(user)

    get(gym_url)
    assert_response(:success)
  end

  test "should only show recent workouts for current user" do
    user = create(:user)
    sign_in(user)

    create(:workout, :completed, user:, name: "gucci")
    create(:workout, :completed, name: "do not wanna see this")

    get(gym_url)

    assert_select("h3", { text: /gucci/, count: 1 })
    assert_select("h3", { text: /do not wanna see this/, count: 0 })
  end
end
