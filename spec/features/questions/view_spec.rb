# frozen_string_literal: true

require 'rails_helper'

feature 'User can view questions', '
  User can view list of questions
  and can choose single question to view it with answers
' do
  given!(:questions) do
    FactoryBot.rewind_sequences
    create_list(:question_with_answers, 4)
  end

  background { visit questions_path }

  scenario 'User tries to view question list' do
    questions.each do |question|
      expect(page).to have_content question.title
    end
  end

  scenario 'User select question from list and view question with answers' do
    questions.each do |question|
      visit questions_path
      click_on question.title

      expect(page).to have_content question.title
      expect(page).to have_content question.body
    end
  end
end
