# frozen_string_literal: true

require "test_helper"

class TestController < ApplicationController
  def index
    render plain: "OK"
  end

  def timezone_check
    render plain: Time.current
  end
end

class ApplicationControllerTest < ActionDispatch::IntegrationTest
  setup do
    Rails.application.routes.draw do
      devise_for :users
      get "/test", to: "test#index"
      get "/timezone_check", to: "test#timezone_check"
    end
  end

  teardown do
    Rails.application.reload_routes!
  end

  test "does nothing when authenticated" do
    user = create :user
    sign_in user

    get "/test"
    assert_response :success
  end

  test "redirects to login when not authenticated" do
    get "/test"

    assert_redirected_to new_user_session_url
    assert_equal "You need to sign in or sign up before continuing.", flash[:alert]
  end

  test "sets the timezone of the current user" do
    user = create :user, time_zone: "Eastern Time (US & Canada)"
    sign_in user
    expected_time = Time.utc(2000).in_time_zone("Eastern Time (US & Canada)")

    travel_to Time.utc(2000) do
      get "/timezone_check"
      assert_response :success

      assert_equal expected_time.to_s, response.body
    end
  end
end
