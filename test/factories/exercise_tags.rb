# frozen_string_literal:true

FactoryBot.define do
  factory :exercise_tag, parent: :tag, class: "ExerciseTag" do
    type { "ExerciseTag" }
  end
end
