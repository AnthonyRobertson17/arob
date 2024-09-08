# frozen_string_literal: true

require "test_helper"

class EquipmentControllerTest < ActionDispatch::IntegrationTest
  def user
    @user ||= create(:user)
  end

  test "get index" do
    sign_in(user)
    create(:equipment, user:, name: "funny equipment")

    get(equipment_index_url)

    assert_response(:success)
  end

  test "get index only returns current users equipment" do
    sign_in(user)
    create(:equipment, user:, name: "funny equipment")
    create(:equipment, name: "should not be shown")

    get(equipment_index_url)

    assert_select("h3", { text: /funny equipment/, count: 1 })
    assert_select("h3", { text: /should not be shown/, count: 0 })
  end

  test "get new" do
    sign_in(user)

    get(new_equipment_url)

    assert_response(:success)
  end

  test "create equipment creates the new record" do
    sign_in(user)

    assert_difference("Equipment.count") do
      post(equipment_index_url, params: { equipment: { name: "New equipment name" } })
    end
  end

  test "create equipment links to the current_user" do
    sign_in(user)

    post(equipment_index_url, params: { equipment: { name: "New equipment name" } })

    new_equipment = Equipment.for_user(user).last

    assert_equal("New equipment name", new_equipment.name)
  end

  test "create equipment assigns the gyms based on the selected gym ids" do
    sign_in(user)

    gym_ids = [
      create(:gym, user:),
      create(:gym, user:),
    ].map(&:id)

    post(equipment_index_url, params: { equipment: { name: "Test", gym_ids: } })

    associated_gym_ids = Equipment.last.gyms.map(&:id)

    gym_ids.each do |id|
      assert_includes(associated_gym_ids, id)
    end
  end

  test "create equipment with http format redirects to equipment index page" do
    sign_in(user)

    post(equipment_index_url, params: { equipment: { name: "New equipment name" } })

    assert_redirected_to(equipment_index_url)
  end

  test "create equipment with turbo_stream format returns OK" do
    sign_in(user)

    post(equipment_index_url(format: :turbo_stream), params: { equipment: { name: "New equipment name" } })

    assert_response(:ok)
  end

  test "show equipment" do
    sign_in(user)
    equipment = create(:equipment, user:, name: "funny equipment")

    get(equipment_url(equipment))

    assert_response(:success)
  end

  test "show equipment raises not found if the equipment belongs to another user" do
    sign_in(user)
    other_equipment = create(:equipment)

    get(equipment_url(other_equipment))

    assert_response(:not_found)
  end

  test "get edit" do
    sign_in(user)
    equipment = create(:equipment, user:, name: "funny equipment")

    get(edit_equipment_url(equipment))

    assert_response(:success)
  end

  test "get edit returns not found if the equipment belongst to another user" do
    sign_in(user)
    other_equipment = create(:equipment)

    get(edit_equipment_url(other_equipment))

    assert_response(:not_found)
  end

  test "update equipment updates the record" do
    sign_in(user)
    equipment = create(:equipment, user:, name: "funny equipment")

    patch(equipment_url(equipment), params: { equipment: { name: "Updated equipment name" } })

    assert_equal("Updated equipment name", equipment.reload.name)
  end

  test "can update gyms" do
    sign_in(user)

    equipment = create(:equipment, user:)
    gym_ids = [
      create(:gym, user:),
      create(:gym, user:),
    ].map(&:id)

    patch(equipment_url(equipment), params: { equipment: { name: "funny workout", gym_ids: } })

    associated_gym_ids = equipment.reload.gyms.map(&:id)

    gym_ids.each do |id|
      assert_includes(associated_gym_ids, id)
    end
  end

  test "update equipment with http format redirecs to the equipment index page" do
    sign_in(user)
    equipment = create(:equipment, user:, name: "funny equipment")

    patch(equipment_url(equipment), params: { equipment: { name: "Updated equipment name" } })

    assert_redirected_to(equipment_index_url)
  end

  test "update equipment with turbo_stream format returns OK" do
    sign_in(user)
    equipment = create(:equipment, user:, name: "funny equipment")

    patch(
      equipment_url(equipment, format: :turbo_stream),
      params: { equipment: { name: "Updated equipment name" } },
    )

    assert_response(:ok)
  end

  test "update equipment returns not found if the equipment belongs to another user" do
    sign_in(user)
    other_equipment = create(:equipment)

    patch(equipment_url(other_equipment), params: { equipment: { name: "Updated equipment name" } })

    assert_response(:not_found)
  end

  test "destroy equipment destroys the record" do
    sign_in(user)
    equipment = create(:equipment, user:, name: "funny equipment")

    assert_difference("Equipment.count", -1) do
      delete(equipment_url(equipment))
    end
  end

  test "destroy equipment with http format redirects to the equipment index page" do
    sign_in(user)
    equipment = create(:equipment, user:, name: "funny equipment")

    delete(equipment_url(equipment))

    assert_redirected_to(equipment_index_url)
  end

  test "destroy equipment returns not found if the equipment belongs to another user" do
    sign_in(user)
    other_equipment = create(:equipment)

    delete(equipment_url(other_equipment))

    assert_response(:not_found)
  end
end
