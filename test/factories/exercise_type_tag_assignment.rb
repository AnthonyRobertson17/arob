# frozen_string_literal:true

FactoryBot.define do
  factory :exercise_type_tag_assignment do
    transient do
      user { build(:user) }
    end

    exercise_type { build(:exercise_type, user:) }
    tag { build(:exercise_type_tag, user:) }
  end
end
