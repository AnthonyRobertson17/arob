# frozen_string_literal: true

FactoryBot.define do
  factory(:gym) do
    user
    sequence(:name) { |n| "gym-#{n}" }
  end
end
