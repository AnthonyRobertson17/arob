# frozen_string_literal: true

FactoryBot.define do
  factory :workout do
    user

    sequence(:name) { |n| "workout-#{n}" }

    trait :started do
      started_at { 2.hours.ago }
    end

    trait :completed do
      started
      completed_at { 1.hour.ago }
    end
  end
end
