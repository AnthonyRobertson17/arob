# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users

  get "profile", to: "users/profile#show"
  get "profile/edit", to: "users/profile#edit"
  patch "profile", to: "users/profile#update"

  get "fitness", to: "fitness#index"
  get "nutrition", to: "nutrition#index"

  resources :equipment, :workout_tags, :exercise_types, :gyms, :exercise_type_tags

  resources :workouts do
    member do
      patch "start", to: "workouts/start#update"
      patch "complete", to: "workouts/complete#update"
    end
    resources :exercises, except: [:index, :show] do
      resources :exercise_sets, except: [:index, :show]
      member do
        patch "move_higher", to: "exercises/reorder#move_higher"
        patch "move_lower", to: "exercises/reorder#move_lower"
      end
    end
  end

  resources :wishlists do
    resources :wishlist_items, except: [:index] do
      collection do
        get "quick_new"
        post "quick_create"
      end
    end
  end

  resources :food_groups, :foods, :serving_units
  resources :serving_definitions, except: [:show]
  resources :meals do
    resources :portions, except: [:index, :show]
  end

  authenticated :user do
    root to: "home#index", as: :authenticated_root
  end
  root to: redirect("/users/sign_in")
end
