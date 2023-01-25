# frozen_string_literal: true

require "application_system_test_case"

class EquipmentTest < ApplicationSystemTestCase
  test "visiting the index" do
    user = login
    create(:equipment, user:)

    visit(equipment_index_url)

    assert_selector("h1", text: "Equipment")
  end

  test "creating equipment" do
    login

    visit(equipment_index_url)
    click_on("Create Equipment")

    assert_current_path(equipment_index_path)

    fill_in("Name", with: "Random equipment name")
    click_on("Create")

    assert_current_path(equipment_index_path)

    assert_text("Random equipment name")
  end

  test "cancel creating a equipment" do
    login

    visit(equipment_index_url)
    click_on("Create Equipment")

    assert_current_path(equipment_index_path)

    fill_in("Name", with: "Random equipment name")
    click_on("Cancel")

    assert_current_path(equipment_index_path)

    assert_no_text("Random equipment name")
  end

  test "editing Equipment" do
    user = login
    create(:equipment, user:)

    visit(equipment_index_url)
    find(".bi-pencil").click

    assert_current_path(equipment_index_path)

    fill_in("Name", with: "something else")
    click_on("Update")

    assert_current_path(equipment_index_path)

    assert_text("something else")
  end

  test "cancel editing a equipment" do
    user = login
    create(:equipment, user:)

    visit(equipment_index_url)
    find(".bi-pencil").click

    assert_current_path(equipment_index_path)

    fill_in("Name", with: "something else")
    click_on("Cancel")

    assert_current_path(equipment_index_path)

    assert_no_text("something else")
  end

  test "destroying Equipment" do
    user = login
    create(:equipment, user:, name: "should be gone")

    visit(equipment_index_url)
    accept_confirm do
      find(".bi-trash3").click
    end

    assert_current_path(equipment_index_path)

    assert_no_text("should be gone")
  end
end
