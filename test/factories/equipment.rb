# frozen_string_literal: true

FactoryBot.define do
  factory :equipment do
    association :user

    sequence(:name) { |n| "equipment-#{n}" }
  end
end
