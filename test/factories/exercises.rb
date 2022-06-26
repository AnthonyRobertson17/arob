# frozen_string_literal: true

FactoryBot.define do
  factory :exercise do
    transient do
      user { build(:user) }
    end

    exercise_type { build(:exercise_type, user:) }
    workout { build(:workout, user:) }
  end
end
