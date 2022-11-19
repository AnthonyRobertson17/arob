# frozen_string_literal: true

FactoryBot.define do
  factory :link do
    association(:linkable, factory: :wishlist_item)
    sequence(:url) { |n| "https://www.google.com/link-#{n}" }
  end
end
