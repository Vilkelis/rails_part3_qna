# frozen_string_literal: true

FactoryBot.define do
  factory :question do
    sequence(:title) { |n| "MyQuestionTitle#{n}" }
    body { 'MyQuestionBody' }
    user

    trait :invalid do
      title { nil }
    end

    trait :with_files do
      files { [ Rack::Test::UploadedFile.new("#{Rails.root}/spec/rails_helper.rb"),
                Rack::Test::UploadedFile.new("#{Rails.root}/spec/spec_helper.rb") ] }
    end

    factory :question_with_answers do
      transient do
        answers_count { 5 }
      end

      after(:create) do |question, evaluator|
        create_list(:answer, evaluator.answers_count, question: question)
      end
    end
  end
end
