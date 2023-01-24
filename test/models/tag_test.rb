# frozen_string_literal:true

require "test_helper"

class TagTest < ActiveSupport::TestCase
  test "name is required" do
    tag = build(:tag, name: "")

    assert_predicate(tag, :invalid?)
  end

  test "type is required" do
    tag = build(:tag, type: nil)

    assert_predicate(tag, :invalid?)
  end

  test "for_user scope only returns gyms for the provided user" do
    user = create(:user)
    expected = create(:tag, user:, type: "WorkoutTag")
    create(:tag, type: "WorkoutTag")

    tags = Tag.for_user(user)

    assert_predicate(tags, :one?)
    assert_equal(expected.id, tags.first.id)
  end
end
