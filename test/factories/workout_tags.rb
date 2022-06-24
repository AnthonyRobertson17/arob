# frozen_string_literal:true

FactoryBot.define do
  factory :workout_tag, parent: :tag, class: "WorkoutTag" do
    type { "WorkoutTag" }
  end
end
