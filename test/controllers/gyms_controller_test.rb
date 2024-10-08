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

    assert_select("h3", { text: /funny gym/, count: 1 })
    assert_select("h3", { text: /should not be shown/, count: 0 })
  end

  test "get index shows equipment count of gyms" do
    sign_in(user)
    gym = create(:gym, user:)
    5.times { create(:equipment, user:, gyms: [gym]) }

    get(gyms_url)

    assert_select("th", "Equipment Count")
    assert_select("td", "5")
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

  test "show shows equipment header and count of equipment" do
    sign_in(user)
    gym = create(:gym, user:)
    create(:equipment, name: "barbell", gyms: [gym])
    create(:equipment, name: "dumbbell", gyms: [gym])

    get(gym_url(gym))

    assert_select("h3", "Equipment")
    assert_select("span.badge", "2")
  end

  test "show gym lists associated equipment" do
    sign_in(user)
    gym = create(:gym, user:)
    create(:equipment, name: "barbell", gyms: [gym])
    create(:equipment, name: "dumbbell", gyms: [gym])

    get(gym_url(gym))

    assert_select("li", "barbell")
    assert_select("li", "dumbbell")
  end

  test "show gym returns not found if the gym belongs to another user" do
    sign_in(user)
    gym = create(:gym)

    get(gym_url(gym))

    assert_response(:not_found)
  end

  test "get edit" do
    sign_in(user)
    gym = create(:gym, user:)
    get(edit_gym_url(gym))

    assert_response(:success)
  end

  test "get edit returns not found if the gym belongs to another user" do
    sign_in(user)
    gym = create(:gym)

    get(edit_gym_url(gym))

    assert_response(:not_found)
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

  test "update gym returns not found if the gym belongs to another user" do
    sign_in(user)
    gym = create(:gym)

    patch(gym_url(gym), params: { gym: { name: "Updated gym name" } })

    assert_response(:not_found)
  end

  test "destroy gym" do
    sign_in(user)
    gym = create(:gym, user:)
    assert_difference("Gym.count", -1) do
      delete(gym_url(gym))
    end

    assert_redirected_to(gyms_url)
  end

  test "destroy gym returns not found if the gym belongs to another user" do
    sign_in(user)
    gym = create(:gym)

    delete(gym_url(gym))

    assert_response(:not_found)
  end
end
