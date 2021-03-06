# frozen_string_literal: true

require 'rails_helper'

feature 'User can view answers to a question' do
  given(:question) do
    create(:question_with_answers)
  end

  background { visit question_path(question) }

  scenario 'User views question with answers' do
    expect(page).to have_content question.title
    expect(page).to have_content question.body

    question.answers.each do |answer|
      expect(page).to have_content answer.body
    end
  end
end
