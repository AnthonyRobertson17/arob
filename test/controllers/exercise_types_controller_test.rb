# frozen_string_literal: true

require "test_helper"

class ExerciseTypesControllerTest < ActionDispatch::IntegrationTest
  def user
    @user ||= create(:user)
  end

  test "get index" do
    sign_in(user)
    create(:exercise_type, user:, name: "test exercise_type")

    get(exercise_types_url)

    assert_response(:success)
  end

  test "get index only returns current users exercise_types" do
    sign_in(user)
    create(:exercise_type, user:, name: "test exercise_type")
    create(:exercise_type, name: "should not be shown")

    get(exercise_types_url)

    assert_select("h3", { text: /test exercise_type/, count: 1 })
    assert_select("h3", { text: /should not be shown/, count: 0 })
  end

  test "get index shows exercise types in case insensitive alphabetical order" do
    sign_in(user)
    create(:exercise_type, name: "CCCCCCCCCCCC", user:)
    create(:exercise_type, name: "bbbbbbbbbbbb", user:)
    create(:exercise_type, name: "AAAAAAAAAAAA", user:)

    get(exercise_types_url)

    a = response.body.index("AAAAAAAAAAAA")
    b = response.body.index("bbbbbbbbbbbb")
    c = response.body.index("CCCCCCCCCCCC")

    assert(a < b, "exercise types are not in alphabetical order")
    assert(b < c, "exercise types are not in alphabetical order")
  end

  test "get new" do
    sign_in(user)

    get(new_exercise_type_url)

    assert_response(:success)
  end

  test "new form lists exercise tags in case insenitive alphabetical order" do
    sign_in(user)
    create(:exercise_type_tag, name: "CCCCCCCCCCCC", user:)
    create(:exercise_type_tag, name: "bbbbbbbbbbbb", user:)
    create(:exercise_type_tag, name: "AAAAAAAAAAAA", user:)

    get(new_exercise_type_url)

    a = response.body.index("AAAAAAAAAAAA")
    b = response.body.index("bbbbbbbbbbbb")
    c = response.body.index("CCCCCCCCCCCC")

    assert(a < b, "exercise type tags are not in alphabetical order")
    assert(b < c, "exercise type tags are not in alphabetical order")
  end

  test "new form shows equipment in case insensitive alphabetical order" do
    sign_in(user)
    create(:equipment, name: "CCCCCCCCCCCC", user:)
    create(:equipment, name: "bbbbbbbbbbbb", user:)
    create(:equipment, name: "AAAAAAAAAAAA", user:)

    get(new_exercise_type_url)

    a = response.body.index("AAAAAAAAAAAA")
    b = response.body.index("bbbbbbbbbbbb")
    c = response.body.index("CCCCCCCCCCCC")

    assert(a < b, "equipment are not in alphabetical order")
    assert(b < c, "equipment are not in alphabetical order")
  end

  test "create exercise_type creates the new record" do
    sign_in(user)

    assert_difference("ExerciseType.count") do
      post(exercise_types_url, params: { exercise_type: { name: "New exercise_type name" } })
    end
  end

  test "create exercise_type with http format redirects to exercise_type index page" do
    sign_in(user)

    post(exercise_types_url, params: { exercise_type: { name: "New exercise_type name" } })

    assert_redirected_to(exercise_types_url)
  end

  test "create exercise_type with turbo_stream format returns OK" do
    sign_in(user)

    post(exercise_types_url(format: :turbo_stream), params: { exercise_type: { name: "New exercise_type name" } })

    assert_response(:ok)
  end

  test "create exercise_type links to the current_user" do
    sign_in(user)

    post(exercise_types_url, params: { exercise_type: { name: "New exercise_type name" } })

    new_exercise_type = ExerciseType.for_user(user).last

    assert_equal("New exercise_type name", new_exercise_type.name)
  end

  test "create exercise_type links the tags based on the selected tag ids" do
    sign_in(user)
    exercise_type_tag_ids = [
      create(:exercise_type_tag, user:),
      create(:exercise_type_tag, user:),
    ].map(&:id)

    post(exercise_types_url, params: { exercise_type: { name: "Test", tag_ids: exercise_type_tag_ids } })

    associated_tag_ids = ExerciseType.last.tags.map(&:id)

    exercise_type_tag_ids.each do |id|
      assert_includes(associated_tag_ids, id)
    end
  end

  test "create exercise_type links the equipment based on the selected equipment ids" do
    sign_in(user)
    equipment_ids = [
      create(:equipment, user:),
      create(:equipment, user:),
    ].map(&:id)

    post(exercise_types_url, params: { exercise_type: { name: "Test", equipment_ids: } })

    associated_equipment_ids = ExerciseType.last.equipment.map(&:id)

    equipment_ids.each do |id|
      assert_includes(associated_equipment_ids, id)
    end
  end

  test "show exercise_type" do
    sign_in(user)

    exercise_type = create(:exercise_type, user:, name: "test exercise_type")
    get(exercise_type_url(exercise_type))

    assert_response(:success)
  end

  test "show exercise_type raises not found if the exercise_type belongs to another user" do
    sign_in(user)
    other_exercise_type = create(:exercise_type)

    assert_raises(ActiveRecord::RecordNotFound) do
      get(exercise_type_url(other_exercise_type))
    end
  end

  test "get edit" do
    sign_in(user)
    exercise_type = create(:exercise_type, user:)

    get(edit_exercise_type_url(exercise_type))

    assert_response(:success)
  end

  test "edit form lists exercise tags in case insenitive alphabetical order" do
    sign_in(user)
    exercise_type = create(:exercise_type, user:)
    create(:exercise_type_tag, name: "CCCCCCCCCCCC", user:)
    create(:exercise_type_tag, name: "bbbbbbbbbbbb", user:)
    create(:exercise_type_tag, name: "AAAAAAAAAAAA", user:)

    get(edit_exercise_type_url(exercise_type))

    a = response.body.index("AAAAAAAAAAAA")
    b = response.body.index("bbbbbbbbbbbb")
    c = response.body.index("CCCCCCCCCCCC")

    assert(a < b, "exercise type tags are not in alphabetical order")
    assert(b < c, "exercise type tags are not in alphabetical order")
  end

  test "edit form shows equipment in case insensitive alphabetical order" do
    sign_in(user)
    exercise_type = create(:exercise_type, user:)
    create(:equipment, name: "CCCCCCCCCCCC", user:)
    create(:equipment, name: "bbbbbbbbbbbb", user:)
    create(:equipment, name: "AAAAAAAAAAAA", user:)

    get(edit_exercise_type_url(exercise_type))

    a = response.body.index("AAAAAAAAAAAA")
    b = response.body.index("bbbbbbbbbbbb")
    c = response.body.index("CCCCCCCCCCCC")

    assert(a < b, "equipment are not in alphabetical order")
    assert(b < c, "equipment are not in alphabetical order")
  end

  test "get edit raises not found if the exercise_type belongst to another user" do
    sign_in(user)
    other_exercise_type = create(:exercise_type)

    assert_raises(ActiveRecord::RecordNotFound) do
      get(edit_exercise_type_url(other_exercise_type))
    end
  end

  test "update exercise_type updates the record" do
    sign_in(user)
    exercise_type = create(:exercise_type, user:)

    patch(exercise_type_url(exercise_type), params: { exercise_type: { name: "Updated exercise_type name" } })

    assert_equal("Updated exercise_type name", exercise_type.reload.name)
  end

  test "update exercise_type with http format redirecs to the exercise_type index page" do
    sign_in(user)
    exercise_type = create(:exercise_type, user:)

    patch(exercise_type_url(exercise_type), params: { exercise_type: { name: "Updated exercise_type name" } })

    assert_redirected_to(exercise_types_url)
  end

  test "update exercise_type with turbo_stream format returns OK" do
    sign_in(user)
    exercise_type = create(:exercise_type, user:)

    patch(
      exercise_type_url(exercise_type, format: :turbo_stream),
      params: { exercise_type: { name: "Updated exercise_type name" } },
    )

    assert_response(:ok)
  end

  test "can update exercise_type tags" do
    sign_in(user)
    exercise_type = create(:exercise_type, user:)
    exercise_type_tag_ids = [
      create(:exercise_type_tag, user:),
      create(:exercise_type_tag, user:),
    ].map(&:id)

    patch(
      exercise_type_url(exercise_type),
      params: { exercise_type: { name: "funny exercise_type", tag_ids: exercise_type_tag_ids } },
    )

    associated_tag_ids = ExerciseType.last.tags.map(&:id)

    exercise_type_tag_ids.each do |id|
      assert_includes(associated_tag_ids, id)
    end
  end

  test "can update exercise_type equipment" do
    sign_in(user)
    exercise_type = create(:exercise_type, user:)
    equipment_ids = [
      create(:equipment, user:),
      create(:equipment, user:),
    ].map(&:id)

    patch(exercise_type_url(exercise_type), params: { exercise_type: { name: "Test", equipment_ids: } })

    associated_equipment_ids = ExerciseType.last.equipment.map(&:id)

    equipment_ids.each do |id|
      assert_includes(associated_equipment_ids, id)
    end
  end

  test "update exercise_type raises not found if the exercise_type belongs to another user" do
    sign_in(user)
    other_exercise_type = create(:exercise_type)

    assert_raises(ActiveRecord::RecordNotFound) do
      patch(exercise_type_url(other_exercise_type), params: { exercise_type: { name: "Updated exercise_type name" } })
    end
  end

  test "destroy exercise_type destroys the record" do
    sign_in(user)
    exercise_type = create(:exercise_type, user:)

    assert_difference("ExerciseType.count", -1) do
      delete(exercise_type_url(exercise_type))
    end
  end

  test "destroy exercise_type with http format redirects to the exercise_type index page" do
    sign_in(user)
    exercise_type = create(:exercise_type, user:)

    delete(exercise_type_url(exercise_type))

    assert_redirected_to(exercise_types_url)
  end

  test "destroy exercise_type with turbo_stream format returns OK" do
    sign_in(user)
    exercise_type = create(:exercise_type, user:)

    delete(exercise_type_url(exercise_type, format: :turbo_stream))

    assert_response(:ok)
  end

  test "destroy exercise_type raises not found if the exercise_type belongs to another user" do
    sign_in(user)
    other_exercise_type = create(:exercise_type)

    assert_raises(ActiveRecord::RecordNotFound) do
      delete(exercise_type_url(other_exercise_type))
    end
  end
end
