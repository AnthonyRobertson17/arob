# frozen_string_literal: true

FactoryBot.define do
  factory :exercise do
    transient do
      user { association :user }
    end

    exercise_type { association :exercise_type, user: }
    workout { association :workout, user: }

    note { "this is the default note for an exercise that was generated via the exercises factory" }
  end
end
