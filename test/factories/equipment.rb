# frozen_string_literal: true

FactoryBot.define do
  factory :equipment do
    user
    sequence(:name) { |n| "equipment-#{n}" }
  end
end
