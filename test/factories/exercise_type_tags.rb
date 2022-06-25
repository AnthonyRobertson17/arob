# frozen_string_literal:true

FactoryBot.define do
  factory :exercise_type_tag, parent: :tag, class: "ExerciseTypeTag" do
    type { "ExerciseTypeTag" }
  end
end
