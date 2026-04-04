# frozen_string_literal: true

require "test_helper"

class Golf::PuttingSessionTest < ActiveSupport::TestCase
  test "session_type is required" do
    session = build(:"golf/putting_session", session_type: nil)
    assert_predicate(session, :invalid?)
  end

  test "started_at is required" do
    session = build(:"golf/putting_session", started_at: nil)
    assert_predicate(session, :invalid?)
  end

  test "in_progress? when completed_at is nil" do
    session = build(:"golf/putting_session")
    assert_predicate(session, :in_progress?)
  end

  test "completed? when completed_at is set" do
    session = build(:"golf/putting_session", :completed)
    assert_predicate(session, :completed?)
  end

  test "for_user scope only returns sessions for the provided user" do
    user = create(:user)
    create(:"golf/putting_session")
    create(:"golf/putting_session", user:)
    assert_predicate(Golf::PuttingSession.for_user(user), :one?)
  end

  test "make_percentage returns nil when no putts" do
    session = create(:"golf/putting_session")
    assert_nil(session.make_percentage)
  end

  test "make_percentage calculates correctly" do
    session = create(:"golf/putting_session")
    create(:"golf/putt", :holed, putting_session: session)
    create(:"golf/putt", putting_session: session)
    create(:"golf/putt", putting_session: session)
    assert_equal(33.3, session.make_percentage)
  end

  test "last_distance returns 6 when no putts" do
    session = create(:"golf/putting_session")
    assert_equal(6, session.last_distance)
  end

  test "last_distance returns most recent putt distance" do
    session = create(:"golf/putting_session")
    create(:"golf/putt", putting_session: session, distance_feet: 4)
    create(:"golf/putt", putting_session: session, distance_feet: 10)
    assert_equal(10, session.last_distance)
  end

  test "complete! sets completed_at" do
    session = create(:"golf/putting_session")
    session.complete!
    assert_predicate(session, :completed?)
  end

  test "complete! raises AlreadyCompletedError if already completed" do
    session = create(:"golf/putting_session", :completed)
    assert_raises(Golf::PuttingSession::AlreadyCompletedError) { session.complete! }
  end
end
