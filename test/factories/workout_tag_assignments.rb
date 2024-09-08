# frozen_string_literal:true

FactoryBot.define do
  factory :workout_tag_assignment do
    association :user
    association :workout, user: user
    association :tag, factory: :workout_tag, user: user
  end
end
