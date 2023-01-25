# frozen_string_literal: true

require "test_helper"

class EquipmentTest < ActiveSupport::TestCase
  test "name is required" do
    equipment = build(:equipment, name: "")

    assert_predicate(equipment, :invalid?)
  end

  test "for_user scope only returns equipment for the provided user" do
    user = create(:user)
    create(:equipment)
    create(:equipment, user:)

    assert_predicate(Equipment.for_user(user), :one?)
  end
end
