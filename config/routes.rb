# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users
  resources :workout_categories
  resources :workouts do
    member do
      patch "start", to: "workouts/start#update"
    end
  end

  authenticated :user do
    root to: "home#index", as: :authenticated_root
  end
  root to: redirect("/users/sign_in")
end
