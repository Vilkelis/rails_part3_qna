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
    (1..4).each do |i|
      expect(page).to have_content "MyQuestionTitle#{i}"
    end
  end

  scenario 'User select question from list and view question with answers' do
    click_on 'MyQuestionTitle1'

    expect(page).to have_content 'MyQuestionTitle1'
    expect(page).to have_content 'MyAnswerText'

    visit questions_path
    click_on 'MyQuestionTitle2'

    expect(page).to have_content 'MyQuestionTitle2'
    expect(page).to have_content 'MyAnswerText'
  end
end
