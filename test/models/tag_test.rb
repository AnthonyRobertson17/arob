# frozen_string_literal:true

require "test_helper"

class TagTest < ActiveSupport::TestCase
  test "name is required" do
    tag = build :tag, name: ""
    assert_predicate tag, :invalid?
  end

  test "type is required" do
    tag = build :tag, type: nil
    assert_predicate tag, :invalid?
  end

  test "for_user scope only returns tags for the provided user" do
    user = create :user
    create :tag
    create :tag, user: user

    assert_predicate Tag.for_user(user), :one?
  end
end
