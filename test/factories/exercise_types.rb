# frozen_string_literal: true

FactoryBot.define do
  factory :exercise_type do
    user

    sequence(:name) { |n| "exercise_type_#{n}" }
  end
end
