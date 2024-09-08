# frozen_string_literal: true

FactoryBot.define do
  factory :exercise do
    association :user
    association :exercise_type, user: user
    association :workout, user: user

    note { "this is the default note for an exercise that was generated via the exercises factory" }
  end
end
