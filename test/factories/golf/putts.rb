# frozen_string_literal: true

FactoryBot.define do
  factory :"golf/putt" do
    putting_session factory: [:"golf/putting_session"]
    holed { false }
    distance_feet { 6 }

    trait :holed do
      holed { true }
    end

    trait :too_hard do
      pace { :too_hard }
    end

    trait :too_soft do
      pace { :too_soft }
    end

    trait :left do
      direction { :left }
    end

    trait :right do
      direction { :right }
    end
  end
end
