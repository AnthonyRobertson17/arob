# frozen_string_literal: true

require "test_helper"

class ExerciseTypesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = create(:user)
    sign_in(@user)
    @exercise_type = create(:exercise_type, user: @user, name: "funny exercise_type")
  end

  test "get index" do
    get(exercise_types_url)
    assert_response(:success)
  end

  test "get index only returns current users exercise_types" do
    create(:exercise_type, name: "should not be shown")

    get(exercise_types_url)

    assert_select("h5", { text: /funny exercise_type/, count: 1 })
    assert_select("h5", { text: /should not be shown/, count: 0 })
  end

  test "get index shows exercise types in case insensitive alphabetical order" do
    create(:exercise_type, name: "CCCCCCC", user: @user)
    create(:exercise_type, name: "bbbbbbb", user: @user)
    create(:exercise_type, name: "AAAAAAA", user: @user)

    get(exercise_types_url)

    a = response.body.index("AAAAAAA")
    b = response.body.index("bbbbbbb")
    c = response.body.index("CCCCCCC")

    assert(a < b)
    assert(b < c)
  end

  test "get new" do
    get(new_exercise_type_url)
    assert_response(:success)
  end

  test "create exercise_type creates the new record" do
    assert_difference("ExerciseType.count") do
      post(exercise_types_url, params: { exercise_type: { name: "New exercise_type name" } })
    end
  end

  test "create exercise_type with http format redirects to exercise_type index page" do
    post(exercise_types_url, params: { exercise_type: { name: "New exercise_type name" } })

    assert_redirected_to(exercise_types_url)
  end

  test "create exercise_type with turbo_stream format returns OK" do
    post(exercise_types_url(format: :turbo_stream), params: { exercise_type: { name: "New exercise_type name" } })

    assert_response(:ok)
  end

  test "create exercise_type links to the current_user" do
    post(exercise_types_url, params: { exercise_type: { name: "New exercise_type name" } })

    new_exercise_type = ExerciseType.for_user(@user).last
    assert_equal("New exercise_type name", new_exercise_type.name)
  end

  test "create exercise_type links the tags based on the selected tag ids" do
    exercise_type_tag_ids = [
      create(:exercise_type_tag, user: @user),
      create(:exercise_type_tag, user: @user),
    ].map(&:id)

    post(exercise_types_url, params: { exercise_type: { name: "Test", tag_ids: exercise_type_tag_ids } })

    associated_tag_ids = ExerciseType.last.tags.map(&:id)

    exercise_type_tag_ids.each do |id|
      assert_includes(associated_tag_ids, id)
    end
  end

  test "show exercise_type" do
    get(exercise_type_url(@exercise_type))
    assert_response(:success)
  end

  test "show exercise_type raises not found if the exercise_type belongs to another user" do
    other_exercise_type = create(:exercise_type)

    assert_raises(ActiveRecord::RecordNotFound) do
      get(exercise_type_url(other_exercise_type))
    end
  end

  test "get edit" do
    get(edit_exercise_type_url(@exercise_type))
    assert_response(:success)
  end

  test "get edit raises not found if the exercise_type belongst to another user" do
    other_exercise_type = create(:exercise_type)

    assert_raises(ActiveRecord::RecordNotFound) do
      get(edit_exercise_type_url(other_exercise_type))
    end
  end

  test "update exercise_type updates the record" do
    patch(exercise_type_url(@exercise_type), params: { exercise_type: { name: "Updated exercise_type name" } })
    assert_equal("Updated exercise_type name", @exercise_type.reload.name)
  end

  test "update exercise_type with http format redirecs to the exercise_type index page" do
    patch(exercise_type_url(@exercise_type), params: { exercise_type: { name: "Updated exercise_type name" } })
    assert_redirected_to(exercise_types_url)
  end

  test "update exercise_type with turbo_stream format returns OK" do
    patch(
      exercise_type_url(@exercise_type, format: :turbo_stream),
      params: { exercise_type: { name: "Updated exercise_type name" } },
    )
    assert_response(:ok)
  end

  test "can update exercise_type tags" do
    exercise_type_tag_ids = [
      create(:exercise_type_tag, user: @user),
      create(:exercise_type_tag, user: @user),
    ].map(&:id)

    patch(
      exercise_type_url(@exercise_type),
      params: { exercise_type: { name: "funny exercise_type", tag_ids: exercise_type_tag_ids } },
    )

    associated_tag_ids = ExerciseType.last.tags.map(&:id)

    exercise_type_tag_ids.each do |id|
      assert_includes(associated_tag_ids, id)
    end
  end

  test "update exercise_type raises not found if the exercise_type belongs to another user" do
    other_exercise_type = create(:exercise_type)

    assert_raises(ActiveRecord::RecordNotFound) do
      patch(exercise_type_url(other_exercise_type), params: { exercise_type: { name: "Updated exercise_type name" } })
    end
  end

  test "destroy exercise_type destroys the record" do
    assert_difference("ExerciseType.count", -1) do
      delete(exercise_type_url(@exercise_type))
    end
  end

  test "destroy exercise_type with http format redirects to the exercise_type index page" do
    delete(exercise_type_url(@exercise_type))

    assert_redirected_to(exercise_types_url)
  end

  test "destroy exercise_type with turbo_stream format returns OK" do
    delete(exercise_type_url(@exercise_type, format: :turbo_stream))

    assert_response(:ok)
  end

  test "destroy exercise_type raises not found if the exercise_type belongs to another user" do
    other_exercise_type = create(:exercise_type)

    assert_raises(ActiveRecord::RecordNotFound) do
      delete(exercise_type_url(other_exercise_type))
    end
  end
end
