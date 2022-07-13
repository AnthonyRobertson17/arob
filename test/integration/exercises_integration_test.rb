# frozen_string_literal:true

require "test_helper"

class ExercisesIntegrationTest < ActionDispatch::IntegrationTest
  setup do
    @user = create(:user)
    sign_in(@user)
    @workout = create(:workout, user: @user)
    @exercise_type = create(:exercise_type, user: @user)
  end

  test "viewing an exercise with a note" do
    exercise_type = create(:exercise_type, user: @user, name: "test exercise type")
    exercise = create(:exercise, workout: @workout, exercise_type:)

    get(workout_url(@workout))

    assert_select("p", { text: /Note:/, count: 1 })
    assert_select("p", { text: exercise.note, count: 1 })
  end

  test "viewing an exercise that has no note does not show an empty section" do
    exercise_type = create(:exercise_type, user: @user, name: "test exercise type")
    create(:exercise, workout: @workout, exercise_type:, note: nil)

    get(workout_url(@workout))
    assert_response(:success)

    assert_select("p", { text: /Note:/, count: 0 })
  end
end
