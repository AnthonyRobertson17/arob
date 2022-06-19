# frozen_string_literal:true

require "test_helper"

class TagsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = create :user
    sign_in @user
  end

  test "get index" do
    create :exercise_tag, user: @user, name: "testing exercise tag"
    create :workout_tag, user: @user, name: "testing workout tag"

    get tags_url
    assert_response :success

    assert_select "h5", { text: /testing exercise tag/, count: 1 }
    assert_select "h5", { text: /testing workout tag/, count: 1 }
  end

  test "get index doesn't show workout categories which don't belong to the current user" do
    create :exercise_tag, name: "should not be able to see this"
    create :workout_tag, name: "not this either"

    get tags_url
    assert_response :success

    assert_select "h5", { text: /should not be able to see this/, count: 0 }
    assert_select "h5", { text: /not this either/, count: 0 }
  end
end
