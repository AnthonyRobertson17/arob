# frozen_string_literal: true

Rails.application.routes.draw do
  resources :workout_categories
  resources :workouts

  root "home#index"
end
