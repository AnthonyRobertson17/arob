# frozen_string_literal:true

FactoryBot.define do
  factory :putting_practice_session do
    user
    hole_distance { 3.0 }
  end
end
