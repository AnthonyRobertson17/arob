# frozen_string_literal: true

FactoryBot.define do
  factory :wishlist_item do
    association :wishlist

    sequence(:name) { |n| "wishlist-item-#{n}" }
  end
end
