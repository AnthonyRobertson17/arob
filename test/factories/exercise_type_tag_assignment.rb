# frozen_string_literal:true

FactoryBot.define do
  factory :exercise_type_tag_assignment do
    association :user
    association :exercise_type, user: user
    association :tag, factory: :exercise_type_tag, user: user
  end
end
