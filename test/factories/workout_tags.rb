# frozen_string_literal:true

FactoryBot.define do
  factory :workout_tag, parent: :tag do
    type { "WorkoutTag" }
  end
end
