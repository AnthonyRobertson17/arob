# frozen_string_literal: true

require "test_helper"

class TestController < ApplicationController
  def index
    render plain: "OK"
  end
end

class ApplicationControllerTest < ActionDispatch::IntegrationTest
  setup do
    Rails.application.routes.draw do
      devise_for :users
      get "/test", to: "test#index"
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
end
