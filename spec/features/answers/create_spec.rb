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

    scenario 'tries to create new answer with attached files' do
      within '#new_answer_form' do
        fill_in 'Body', with: 'Test question body'

        attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb","#{Rails.root}/spec/spec_helper.rb"]

        click_on 'Create answer'
      end

      expect(page).to have_link "rails_helper.rb"
      expect(page).to have_link "spec_helper.rb"
    end
  end

  scenario 'Unauthenticated user tries to create new answer' do
    visit_question_page(question)
    fill_in 'Body', with: 'Test answer for the question'
    click_on 'Create answer'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
