# frozen_string_literal: true

require "test_helper"

class LinkTest < ActiveSupport::TestCase
  test "url is required" do
    link = build(:link, url: "")

    assert_predicate(link, :invalid?)
  end

  test "url must be a valid URI" do
    link = build(:link, url: "foo")

    assert_predicate(link, :invalid?)
  end
end
