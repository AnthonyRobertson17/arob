# frozen_string_literal: true

require "test_helper"

class GymsControllerTest < ActionDispatch::IntegrationTest
  def user
    @user ||= create(:user)
  end

  test "get index" do
    sign_in(user)
    create(:gym, user:)

    get(gyms_url)

    assert_response(:success)
  end

  test "get index only returns current users gyms" do
    sign_in(user)
    create(:gym, user:, name: "funny gym")
    create(:gym, name: "should not be shown")

    get(gyms_url)

    assert_select("h5", { text: /funny gym/, count: 1 })
    assert_select("h5", { text: /should not be shown/, count: 0 })
  end

  test "get index shows gyms in case insensitive alphabetical order" do
    sign_in(user)
    create(:gym, name: "CCCCCCCCCCCC", user:)
    create(:gym, name: "bbbbbbbbbbbb", user:)
    create(:gym, name: "AAAAAAAAAAAA", user:)

    get(gyms_url)

    a = response.body.index("AAAAAAAAAAAA")
    b = response.body.index("bbbbbbbbbbbb")
    c = response.body.index("CCCCCCCCCCCC")

    assert(a < b, "gyms are not in alphabetical order")
    assert(b < c, "gyms types are not in alphabetical order")
  end

  test "get new" do
    sign_in(user)
    get(new_gym_url)

    assert_response(:success)
  end

  test "create gym with html format redirects to show" do
    sign_in(user)
    post(gyms_url, params: { gym: { name: "Random Gym" } })

    assert_redirected_to(gym_url(Gym.last))
  end

  test "create gym with turbo_stream format responds with OK" do
    sign_in(user)
    post(gyms_url(format: :turbo_stream), params: { gym: { name: "Random Gym" } })

    assert_response(:ok)
  end

  test "create gym links to the current_user" do
    sign_in(user)
    post(gyms_url, params: { gym: { name: "New gym name" } })

    new_gym = Gym.for_user(@user).last

    assert_equal("New gym name", new_gym.name)
  end

  test "show gym includes name" do
    sign_in(user)
    gym = create(:gym, user:, name: "testing 123")

    get(gym_url(gym))

    assert_response(:success)
    assert_select("h1", { text: /testing 123/, count: 1 })
  end

  test "show gym raises not found if the gym belongs to another user" do
    sign_in(user)
    gym = create(:gym)

    assert_raises(ActiveRecord::RecordNotFound) do
      get(gym_url(gym))
    end
  end

  test "get edit" do
    sign_in(user)
    gym = create(:gym, user:)
    get(edit_gym_url(gym))

    assert_response(:success)
  end

  test "get edit raises not found if the gym belongs to another user" do
    sign_in(user)
    gym = create(:gym)

    assert_raises(ActiveRecord::RecordNotFound) do
      get(edit_gym_url(gym))
    end
  end

  test "update gym name" do
    sign_in(user)
    gym = create(:gym, user:)

    patch(gym_url(gym), params: { gym: { name: "Updated gym name" } })

    gym.reload

    assert_equal("Updated gym name", gym.name)
  end

  test "update gym with html format redirects to the gym show page" do
    sign_in(user)
    gym = create(:gym, user:)
    patch(gym_url(gym), params: { gym: { name: "Updated gym name" } })

    assert_redirected_to(gym_url(gym))
  end

  test "update gym with turbo_stream format responds with OK" do
    sign_in(user)
    gym = create(:gym, user:)
    patch(gym_url(gym, format: :turbo_stream), params: { gym: { name: "Updated gym name" } })

    assert_response(:ok)
  end

  test "update gym raises not found if the gym belongs to another user" do
    sign_in(user)
    gym = create(:gym)

    assert_raises(ActiveRecord::RecordNotFound) do
      patch(gym_url(gym), params: { gym: { name: "Updated gym name" } })
    end
  end

  test "destroy gym" do
    sign_in(user)
    gym = create(:gym, user:)
    assert_difference("Gym.count", -1) do
      delete(gym_url(gym))
    end

    assert_redirected_to(gyms_url)
  end

  test "destroy gym raises not found if the gym belongs to another user" do
    sign_in(user)
    gym = create(:gym)

    assert_raises(ActiveRecord::RecordNotFound) do
      delete(gym_url(gym))
    end
  end
end
