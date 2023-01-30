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

  test "get index lists all equipment for each exercise type" do
    sign_in(user)
    exercise_type = create(:exercise_type, user:)
    create(:equipment, user:, exercise_types: [exercise_type], name: "TEST EQUIPMENT 1")
    create(:equipment, user:, exercise_types: [exercise_type], name: "TEST EQUIPMENT 2")

    get(exercise_types_url)

    assert_select("turbo-frame#exercise_type_#{exercise_type.id}") do
      assert_select("h5", "TEST EQUIPMENT 1")
      assert_select("h5", "TEST EQUIPMENT 2")
    end
  end

  test "get new" do
    sign_in(user)

    get(new_exercise_type_url)

    assert_response(:success)
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

  test "show exercise_type includes equipment header and count of equipment" do
    sign_in(user)
    exercise_type = create(:exercise_type, user:)
    create(:equipment, name: "barbell", exercise_types: [exercise_type])
    create(:equipment, name: "dumbbell", exercise_types: [exercise_type])

    get(exercise_type_url(exercise_type))

    assert_select("h3", "Equipment")
    assert_select("span.badge", "2")
  end

  test "show exercise_type includes list of associated equipment" do
    sign_in(user)
    exercise_type = create(:exercise_type, user:)
    create(:equipment, name: "barbell", exercise_types: [exercise_type])
    create(:equipment, name: "dumbbell", exercise_types: [exercise_type])

    get(exercise_type_url(exercise_type))

    assert_select("li", "barbell")
    assert_select("li", "dumbbell")
  end

  test "show exercise_type includes exercises header and count of exercises" do
    sign_in(user)
    exercise_type = create(:exercise_type, user:)
    create(:exercise, exercise_type:, workout: create(:workout, user:))
    create(:exercise, exercise_type:, workout: create(:workout, user:))

    get(exercise_type_url(exercise_type))

    assert_select("h3", "Exercises")
    assert_select("span.badge", "2")
  end

  test "show exercise_type includes list of associated exercises" do
    sign_in(user)
    exercise_type = create(:exercise_type, user:)
    create(:exercise, exercise_type:, workout: create(:workout, user:, name: "Workout 1"))
    create(:exercise, exercise_type:, workout: create(:workout, user:, name: "Workout 2"))

    get(exercise_type_url(exercise_type))

    assert_select("h4", "Workout 1")
    assert_select("h4", "Workout 2")
  end

  test "show exercise_type includes exercise sets for related exercises" do
    sign_in(user)
    exercise_type = create(:exercise_type, user:)
    create(
      :exercise,
      exercise_type:,
      workout: create(:workout, user:),
      exercise_sets: [
        create(:exercise_set, weight: 7.5, repetitions: 15),
      ],
    )

    get(exercise_type_url(exercise_type))

    assert_select("div", "7.5")
    assert_select("div", "15")
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
