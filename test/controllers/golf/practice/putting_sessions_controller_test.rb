# frozen_string_literal: true

require "test_helper"

module Golf
  module Practice
    class PuttingSessionsControllerTest < ActionDispatch::IntegrationTest
      def user
        @user ||= create(:user)
      end

      setup do
        sign_in(user)
      end

      test "get index" do
        create(:"golf/putting_session", user:)
        get(golf_practice_putting_sessions_url)

        assert_response(:success)
      end

      test "get index only returns current user's sessions" do
        create(:"golf/putting_session", user:, session_type: :putting_mat)
        create(:"golf/putting_session", session_type: :practice_green)
        get(golf_practice_putting_sessions_url)

        assert_select("turbo-frame", count: 1)
      end

      test "get new" do
        get(new_golf_practice_putting_session_url)

        assert_response(:success)
      end

      test "create putting session" do
        assert_difference("Golf::PuttingSession.count") do
          post(golf_practice_putting_sessions_url, params: { golf_putting_session: { session_type: :putting_mat } })
        end
        assert_redirected_to(golf_practice_putting_session_url(Golf::PuttingSession.last))
      end

      test "create sets started_at" do
        post(golf_practice_putting_sessions_url, params: { golf_putting_session: { session_type: :putting_mat } })

        assert_not_nil(Golf::PuttingSession.last.started_at)
      end

      test "create sets user to current user" do
        post(golf_practice_putting_sessions_url, params: { golf_putting_session: { session_type: :putting_mat } })

        assert_equal(user, Golf::PuttingSession.last.user)
      end

      test "get show" do
        session = create(:"golf/putting_session", user:)
        get(golf_practice_putting_session_url(session))

        assert_response(:success)
      end

      test "cannot view another user's session" do
        other_session = create(:"golf/putting_session")
        get(golf_practice_putting_session_url(other_session))

        assert_response(:not_found)
      end

      test "destroy putting session" do
        session = create(:"golf/putting_session", user:)
        assert_difference("Golf::PuttingSession.count", -1) do
          delete(golf_practice_putting_session_url(session))
        end
        assert_redirected_to(golf_practice_putting_sessions_url)
      end
    end
  end
end
