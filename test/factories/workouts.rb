# frozen_string_literal: true

FactoryBot.define do
  factory :workout do
    user
    sequence(:name) { |n| "workout-#{n}" }
    workout_category

    trait :started do
      started_at { 1.hour.ago }
    end

    trait :completed do
      started
      completed_at { 1.hour.ago }
    end
  end
end
