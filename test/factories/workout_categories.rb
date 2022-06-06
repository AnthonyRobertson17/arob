# frozen_string_literal:true

FactoryBot.define do
  factory :workout_category do
    sequence(:name) { |n| "category-#{n}" }
  end
end
