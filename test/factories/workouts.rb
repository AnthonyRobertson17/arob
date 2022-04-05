# frozen_string_literal: true

FactoryBot.define do
  factory :workout do
    name { "WorkoutName" }
  end

  trait :started do
    started_at { 1.hour.ago }
  end

  trait :completed do
    started
    completed_at { 1.hour.ago }
  end
end
