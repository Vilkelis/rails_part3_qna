# frozen_string_literal: true

FactoryBot.define do
  factory :answer do
    body { 'MyText' }
    question_id { 'MyString' }
    relation { 'MyString' }
  end
end
