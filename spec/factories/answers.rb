# frozen_string_literal: true

FactoryBot.define do
  factory :answer do
    sequence(:body) { |n| "My Answer Text #{n}" }
    question
    user
    best { false }

    trait :invalid do
      body { nil }
    end
  end
end
