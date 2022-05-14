# frozen_string_literal: true

Rails.application.routes.draw do
  resources :workout_categories
  resources :workouts do
    member do
      patch "start", to: "workouts/start#update"
    end
  end

  root "home#index"
end
