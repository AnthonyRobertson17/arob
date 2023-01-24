# frozen_string_literal: true

require "test_helper"

class GymTest < ActiveSupport::TestCase
  test "name is required" do
    gym = build(:gym, name: "")

    assert_predicate(gym, :invalid?)
  end

  test "for_user scope only returns gyms for the provided user" do
    user = create(:user)
    expected = create(:gym, user:)
    create(:gym)

    gyms = Gym.for_user(user)

    assert_predicate(gyms, :one?)
    assert_equal(expected.id, gyms.first.id)
  end
end
