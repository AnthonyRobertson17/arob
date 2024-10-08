# frozen_string_literal: true

FactoryBot.define do
  factory(:user) do
    sequence(:email) { |n| "jim.halpert#{n}@dundermifflin.com" }
    password { "password12345" }
  end
end
