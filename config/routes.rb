# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users

  get "profile", to: "users/profile#show"
  get "profile/edit", to: "users/profile#edit"
  patch "profile", to: "users/profile#update"

  get "gym", to: "gym#index"

  resources :workout_tags
  resources :exercise_types
  resources :exercise_type_tags
  resources :workouts do
    member do
      patch "start", to: "workouts/start#update"
      patch "complete", to: "workouts/complete#update"
    end
    resources :exercises, except: [:index, :show] do
      resources :exercise_sets, except: [:index, :show]
      member do
        patch "swap_position", to: "exercises/swap_position#update"
      end
    end
  end

  resources :wishlists

  authenticated :user do
    root to: "home#index", as: :authenticated_root

  end
  root to: redirect("/users/sign_in")
end
