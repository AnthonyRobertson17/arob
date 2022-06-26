# frozen_string_literal:true

require "test_helper"

class TagsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = create :user
    sign_in @user
  end

  test "get index shows workout tags" do
    create :workout_tag, user: @user, name: "testing workout tag"
    create :workout_tag, name: "should not see"

    get tags_url
    assert_response :success

    assert_select "h5", { text: /testing workout tag/, count: 1 }
    assert_select "h5", { text: /should not see/, count: 0 }
  end

  test "get index hides workout tag section if the user doesn't have any" do
    get tags_url
    assert_response :success

    assert_select "h3", { text: /Workout Tags/, count: 0 }
  end

  test "get index shows exercise_type tags" do
    create :exercise_type_tag, user: @user, name: "testing exercise_type tag"
    create :exercise_type_tag, name: "should not see"

    get tags_url
    assert_response :success

    assert_select "h5", { text: /testing exercise_type tag/, count: 1 }
    assert_select "h5", { text: /should not see/, count: 0 }
  end

  test "get index hides exercise type tag section if the user doesn't have any" do
    get tags_url
    assert_response :success

    assert_select "h3", { text: /Exercise Type Tags/, count: 0 }
  end
end
