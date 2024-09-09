# frozen_string_literal:true

FactoryBot.define do
  factory :exercise_type_tag_assignment do
    transient do
      user { association :user }
    end

    exercise_type { association :exercise_type, user: }
    tag { association :exercise_type_tag, user: }
  end
end
