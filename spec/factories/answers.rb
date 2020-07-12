# frozen_string_literal: true

FactoryBot.define do
  factory :answer do
    sequence(:body) { |n| "My Answer Text #{n}" }
    question
    user
    best { false }

    trait :with_files do
      files { [ Rack::Test::UploadedFile.new("#{Rails.root}/spec/rails_helper.rb"),
                Rack::Test::UploadedFile.new("#{Rails.root}/spec/spec_helper.rb") ] }
    end

    trait :invalid do
      body { nil }
    end
  end
end
