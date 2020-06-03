# frozen_string_literal: true

FactoryBot.define do
  factory :question do
    sequence(:title) { |n| "MyQuestionTitle#{n}" }
    body { 'MyQuestionBody' }

    trait :invalid do
      title { nil }
    end
  end
end
