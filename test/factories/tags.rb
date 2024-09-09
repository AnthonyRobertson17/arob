# frozen_string_literal:true

FactoryBot.define do
  factory :tag do
    user

    sequence(:name) { |n| "tag-#{n}" }
    type { "invalid" } # This factory is abstract and this is meant to be overwritten by subclasses
  end
end
