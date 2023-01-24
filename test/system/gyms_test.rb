# frozen_string_literal: true

require "application_system_test_case"

class GymsTest < ApplicationSystemTestCase
  test "visiting the index" do
    user = login
    create(:gym, user:)

    visit(gyms_url)

    assert_selector("h1", text: "Gyms")
  end

  test "creating gym" do
    login

    visit(gyms_url)
    click_on("Create Gym")

    assert_current_path(gyms_path)

    fill_in("Name", with: "Random gym name")
    click_on("Create")

    assert_current_path(gyms_path)

    assert_text("Random gym name")
  end

  test "cancel creating a gym" do
    login

    visit(gyms_url)
    click_on("Create Gym")

    assert_current_path(gyms_path)

    fill_in("Name", with: "Random gym name")
    click_on("Cancel")

    assert_current_path(gyms_path)

    assert_no_text("Random gym name")
  end

  test "editing Gyms" do
    user = login
    create(:gym, user:)

    visit(gyms_url)
    find(".bi-pencil").click

    assert_current_path(gyms_path)

    fill_in("Name", with: "something else")
    click_on("Update")

    assert_current_path(gyms_path)

    assert_text("something else")
  end

  test "cancel editing a gym" do
    user = login
    create(:gym, user:)

    visit(gyms_url)
    find(".bi-pencil").click

    assert_current_path(gyms_path)

    fill_in("Name", with: "something else")
    click_on("Cancel")

    assert_current_path(gyms_path)

    assert_no_text("something else")
  end

  test "destroying Gym" do
    user = login
    create(:gym, user:, name: "should be gone")

    visit(gyms_url)
    accept_confirm do
      find(".bi-trash3").click
    end

    assert_current_path(gyms_path)

    assert_no_text("should be gone")
  end
end
