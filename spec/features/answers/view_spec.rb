# frozen_string_literal: true

require 'rails_helper'

feature 'User can view answers to a question' do
  given(:question) do
    FactoryBot.rewind_sequences
    create(:question_with_answers)
  end

  background { visit question_path(question) }

  scenario 'User views question with answers' do
    expect(page).to have_content 'MyQuestionTitle1'
    expect(page).to have_content 'MyAnswerText'
  end
end
