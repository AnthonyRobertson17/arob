# frozen_string_literal:true

require "test_helper"

class PracticePuttTest < ActiveSupport::TestCase
  test "holed_out is required" do
    practice_putt = build(:practice_putt, sunk: nil)

    assert_predicate(practice_putt, :invalid?)
  end

  test "non perfect distance for holed out shots is invalid" do
    practice_putt = build(:practice_putt, sunk: true, distance: :long)

    assert_predicate(practice_putt, :invalid?)
  end

  test "non perfect distance for non holed out shots is valid" do
    practice_putt = build(:practice_putt, sunk: false, distance: :long)

    assert_predicate(practice_putt, :valid?)
  end

  test "non-lip or straight direction is invalid when the putt is holed out" do
    practice_putt = build(:practice_putt, sunk: true, direction: :left)

    assert_predicate(practice_putt, :invalid?)
  end

  test "non-lip or straight direction is valid when putt is not holed out" do
    practice_putt = build(:practice_putt, sunk: false, direction: :left)

    assert_predicate(practice_putt, :valid?)
  end
end
