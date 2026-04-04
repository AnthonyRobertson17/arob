# frozen_string_literal: true

require "test_helper"

module Golf
  class PuttTest < ActiveSupport::TestCase
    test "holed defaults to false" do
      putt = build(:"golf/putt")

      assert_not(putt.holed)
    end

    test "distance_feet must be greater than 0 when present" do
      putt = build(:"golf/putt", distance_feet: 0)

      assert_predicate(putt, :invalid?)
    end

    test "distance_feet can be nil" do
      putt = build(:"golf/putt", distance_feet: nil)

      assert_predicate(putt, :valid?)
    end

    test "holed scope returns only holed putts" do
      session = create(:"golf/putting_session")
      create(:"golf/putt", :holed, putting_session: session)
      create(:"golf/putt", putting_session: session)

      assert_predicate(session.putts.holed, :one?)
    end

    test "missed scope returns only missed putts" do
      session = create(:"golf/putting_session")
      create(:"golf/putt", :holed, putting_session: session)
      create(:"golf/putt", putting_session: session)

      assert_predicate(session.putts.missed, :one?)
    end
  end
end
