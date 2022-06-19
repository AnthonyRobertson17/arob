# frozen_string_literal:true

FactoryBot.define do
  factory :exercise_tag, parent: :tag do
    type { "ExerciseTag" }
  end
end
