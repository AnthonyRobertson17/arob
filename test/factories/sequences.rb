# frozen_string_literal: true

FactoryBot.define do
  sequence(:email) { |i| "user-#{i}@email.com" }
  sequence(:name) { |i| "Random Name #{i}" }
end
