# frozen_string_literal: true

FactoryBot.define do
  factory :exercise_category do
    user
    sequence(:name) { |n| "exercise-category-#{n}" }
  end
end
