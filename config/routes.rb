# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users

  get "profile", to: "users/profile#show"
  get "profile/edit", to: "users/profile#edit"
  patch "profile", to: "users/profile#update"


  resources :workout_tags
  resources :exercise_types
  resources :exercise_type_tags
  resources :workouts do
    member do
      patch "start", to: "workouts/start#update"
      patch "complete", to: "workouts/complete#update"
    end
    resources :exercises, except: [:index, :show]
  end

  authenticated :user do
    root to: "home#index", as: :authenticated_root
  end
  root to: redirect("/users/sign_in")
end
