# frozen_string_literal:true

require "test_helper"

class PuttingPracticeSessionTest < ActiveSupport::TestCase
  test "hole_distance is required" do
    putting_practice_session = build(:putting_practice_session, hole_distance: nil)

    assert_predicate(putting_practice_session, :invalid?)
  end

  test "hole_distance of 0 is invalid" do
    putting_practice_session = build(:putting_practice_session, hole_distance: 0)

    assert_predicate(putting_practice_session, :invalid?)
  end

  test "hole_distance less than 0 is invalid" do
    putting_practice_session = build(:putting_practice_session, hole_distance: -0.1)

    assert_predicate(putting_practice_session, :invalid?)
  end

  test "hole_distance greater than 0 is valid" do
    putting_practice_session = build(:putting_practice_session, hole_distance: 0.1)

    assert_predicate(putting_practice_session, :valid?)
  end

  test "for_user scope only returns gyms for the provided user" do
    user = create(:user)
    expected = create(:putting_practice_session, user:)
    create(:putting_practice_session)

    putting_practice_session = PuttingPracticeSession.for_user(user)

    assert_predicate(putting_practice_session, :one?)
    assert_equal(expected.id, putting_practice_session.first.id)
  end
end
