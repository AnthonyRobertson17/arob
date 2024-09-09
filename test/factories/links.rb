# frozen_string_literal: true

FactoryBot.define do
  factory :link do
    linkable { association :wishlist_item }

    sequence(:url) { |n| "https://www.google.com/link-#{n}" }
  end
end
