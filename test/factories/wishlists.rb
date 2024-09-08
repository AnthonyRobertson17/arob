# frozen_string_literal: true

FactoryBot.define do
  factory :wishlist do
    association :user

    sequence(:name) { |n| "wishlist-#{n}" }
  end
end
