# frozen_string_literal:true

FactoryBot.define do
  factory :workout_tag_assignment do
    transient do
      user { association :user }
    end

    workout { association :workout, user: }
    tag { association :workout_tag, user: }
  end
end
