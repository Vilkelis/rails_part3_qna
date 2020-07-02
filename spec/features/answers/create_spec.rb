# frozen_string_literal: true

require 'rails_helper'

feature 'Only authenticated user can create answer from question page', '
  Only authenticated user can create new answer for question from question page
' do
  given(:user) { create(:user) }
  given!(:question) { create(:question) }

  describe 'Authenticated user', js: true do
    background { visit_question_page(question, user) }

    scenario 'tries to create new answer for question with correct attributes' do
      fill_in 'Body', with: 'Test answer for the question'
      click_on 'Create answer'

      expect(current_path).to eq question_path(question)
      expect(page).to have_content 'Answer created.'
      within '.answers' do
        expect(page).to have_content 'Test answer for the question'
      end
    end

    scenario 'tries to create new answer for question with incorrect attributes' do
      click_on 'Create answer'

      expect(page).to have_content "Body can't be blank"
    end
  end

  scenario 'Unauthenticated user tries to create new answer' do
    visit_question_page(question)
    fill_in 'Body', with: 'Test answer for the question'
    click_on 'Create answer'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
