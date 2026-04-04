# frozen_string_literal: true

require "test_helper"

class Golf::Practice::PuttsControllerTest < ActionDispatch::IntegrationTest
  def user
    @user ||= create(:user)
  end

  def putting_session
    @putting_session ||= create(:"golf/putting_session", user:)
  end

  setup do
    sign_in(user)
  end

  test "create putt" do
    assert_difference("Golf::Putt.count") do
      post(golf_practice_putting_session_putts_url(putting_session),
        params: { golf_putt: { holed: false, pace: :perfect, direction: :on_target, distance_feet: 6 } })
    end
    assert_redirected_to(golf_practice_putting_session_url(putting_session))
  end

  test "create putt with turbo_stream format" do
    post(golf_practice_putting_session_putts_url(putting_session, format: :turbo_stream),
      params: { golf_putt: { holed: true, distance_feet: 10 } })
    assert_response(:ok)
  end

  test "cannot create putt for another user's session" do
    other_session = create(:"golf/putting_session")
    post(golf_practice_putting_session_putts_url(other_session),
      params: { golf_putt: { holed: false } })
    assert_response(:not_found)
  end

  test "destroy putt" do
    putt = create(:"golf/putt", putting_session:)
    assert_difference("Golf::Putt.count", -1) do
      delete(golf_practice_putting_session_putt_url(putting_session, putt))
    end
    assert_redirected_to(golf_practice_putting_session_url(putting_session))
  end

  test "destroy putt with turbo_stream format" do
    putt = create(:"golf/putt", putting_session:)
    delete(golf_practice_putting_session_putt_url(putting_session, putt, format: :turbo_stream))
    assert_response(:ok)
  end
end
