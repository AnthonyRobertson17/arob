# frozen_string_literal:true

require "test_helper"

class ExerciseTypeTagsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = create(:user)
    sign_in(@user)
  end

  test "get index" do
    create(:exercise_type_tag, user: @user, name: "testing exercise_type tag")

    get(exercise_type_tags_url)

    assert_response(:success)

    assert_select("h5", { text: /testing exercise_type tag/, count: 1 })
  end

  test "get index doesn't show exercise_type_tags which don't belong to the current user" do
    create(:exercise_type_tag, name: "should not be able to see this")

    get(exercise_type_tags_url)

    assert_response(:success)

    assert_select("h5", { text: /should not be able to see this/, count: 0 })
  end

  test "get index shows workout_tags in case insensitive alphabetical order" do
    create(:exercise_type_tag, name: "CCCCCCCCCCCC", user: @user)
    create(:exercise_type_tag, name: "bbbbbbbbbbbb", user: @user)
    create(:exercise_type_tag, name: "AAAAAAAAAAAA", user: @user)

    get(exercise_type_tags_url)

    a = response.body.index("AAAAAAAAAAAA")
    b = response.body.index("bbbbbbbbbbbb")
    c = response.body.index("CCCCCCCCCCCC")

    assert(a < b, "exercise_type_tags are not in alphabetical order")
    assert(b < c, "exercise_type_tags are not in alphabetical order")
  end

  test "get new" do
    get(new_exercise_type_tag_url)

    assert_response(:success)
  end

  test "create exercise_type_tag creates the record" do
    assert_difference("ExerciseTypeTag.count") do
      post(exercise_type_tags_url, params: { exercise_type_tag: { name: "Random Tag" } })
    end
  end

  test "create exercise_type_tag with html format redirects to show" do
    post(exercise_type_tags_url, params: { exercise_type_tag: { name: "Random Tag" } })

    assert_redirected_to(exercise_type_tag_url(ExerciseTypeTag.last))
  end

  test "create exercise_type_tag with turbo_stream format responds with OK" do
    post(exercise_type_tags_url(format: :turbo_stream), params: { exercise_type_tag: { name: "Random Tag" } })

    assert_response(:ok)
  end

  test "create exercise_type_tag links to the current_user" do
    post(exercise_type_tags_url, params: { exercise_type_tag: { name: "Random Tag" } })

    new_exercise_type_tag = ExerciseTypeTag.for_user(@user).last

    assert_equal("Random Tag", new_exercise_type_tag.name)
  end

  test "show exercise_type_tag" do
    exercise_type_tag = create(:exercise_type_tag, user: @user)

    get(exercise_type_tag_url(exercise_type_tag))

    assert_response(:success)
  end

  test "show exercise_type_tag raises not found if exercise_type_tag belongs to another user" do
    exercise_type_tag = create(:exercise_type_tag)

    assert_raises(ActiveRecord::RecordNotFound) do
      get(exercise_type_tag_url(exercise_type_tag))
    end
  end

  test "get edit" do
    exercise_type_tag = create(:exercise_type_tag, user: @user)

    get(edit_exercise_type_tag_url(exercise_type_tag))

    assert_response(:success)
  end

  test "get edit raises not found if exercise_type_tag is not for the current user" do
    exercise_type_tag = create(:exercise_type_tag)

    assert_raises(ActiveRecord::RecordNotFound) do
      get(edit_exercise_type_tag_url(exercise_type_tag))
    end
  end

  test "update exercise_type_tag with html format redirects to show" do
    exercise_type_tag = create(:exercise_type_tag, user: @user)

    patch(exercise_type_tag_url(exercise_type_tag), params: { exercise_type_tag: { name: "New ExerciseType Name" } })

    assert_redirected_to(exercise_type_tag_url(exercise_type_tag))
  end

  test "update exercise_type_tag with turbo_stream format responss with OK" do
    exercise_type_tag = create(:exercise_type_tag, user: @user)

    patch(
      exercise_type_tag_url(exercise_type_tag, format: :turbo_stream),
      params: { exercise_type_tag: { name: "New ExerciseType Name" } },
    )

    assert_response(:ok)
  end

  test "update exercise_type_tag raises not found if exercise_type_tag belongs to another user" do
    exercise_type_tag = create(:exercise_type_tag)

    assert_raises(ActiveRecord::RecordNotFound) do
      patch(exercise_type_tag_url(exercise_type_tag), params: { exercise_type_tag: { name: "New ExerciseType Name" } })
    end
  end

  test "destroy exercise_type_tag destroys the record" do
    exercise_type_tag = create(:exercise_type_tag, user: @user)

    assert_difference("ExerciseTypeTag.count", -1) do
      delete(exercise_type_tag_url(exercise_type_tag))
    end
  end

  test "destroy exercise_type_tag with html format redirects to index" do
    exercise_type_tag = create(:exercise_type_tag, user: @user)

    delete(exercise_type_tag_url(exercise_type_tag))

    assert_redirected_to(exercise_type_tags_url)
  end

  test "destroy exercise_type_tag with turbo_stream format responds with OK" do
    exercise_type_tag = create(:exercise_type_tag, user: @user)

    delete(exercise_type_tag_url(exercise_type_tag, format: :turbo_stream))

    assert_response(:ok)
  end

  test "destroy exercise_type_tag raises not found if exercise_type_tag belongs to another user" do
    exercise_type_tag = create(:exercise_type_tag)

    assert_raises(ActiveRecord::RecordNotFound) do
      delete(exercise_type_tag_url(exercise_type_tag))
    end
  end
end
