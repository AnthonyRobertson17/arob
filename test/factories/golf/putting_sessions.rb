# frozen_string_literal: true

FactoryBot.define do
  factory :"golf/putting_session" do
    user
    session_type { :putting_mat }
    started_at { Time.current }

    trait :practice_green do
      session_type { :practice_green }
    end

    trait :completed do
      completed_at { 30.minutes.from_now }
    end
  end
end
