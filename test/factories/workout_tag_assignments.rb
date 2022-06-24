# frozen_string_literal:true

FactoryBot.define do
  factory :workout_tag_assignment do
    transient do
      user { build(:user) }
    end

    workout { build(:workout, user:) }
    tag { build(:workout_tag, user:) }
  end
end
