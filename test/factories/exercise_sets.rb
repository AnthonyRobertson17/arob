# frozen_string_literal:true

FactoryBot.define do
  factory :exercise_set do
    exercise
    repetitions { 10 }
    weight { 12.5 }
  end
end
