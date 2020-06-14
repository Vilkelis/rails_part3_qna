# frozen_string_literal: true

FactoryBot.define do
  sequence(:email) { |n| "user#{n}@test.ru" }

  factory :user do
    email
    password { '12345678' }
    password_confirmation { '12345678' }
  end
end
