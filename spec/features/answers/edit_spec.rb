# frozen_string_literal: true

require 'rails_helper'

feature 'Only authenticated user can edit answer from question page', '
  Only authenticated user can edit your own answer for question from question page,
  but can not edit not owned him answers
' do
  given(:user) { create(:user) }
  given(:another_user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question, user: user) }

  scenario 'Unauthenticated user can not edit answers' do
    visit_question_page(question)
    within '.answers-list' do
      expect(page).to_not have_link 'Edit answer'
    end
  end

  describe 'Authenticated user', js: true do
    scenario 'tries to edit his answer for question with correct attributes' do
      visit_question_page(question, user)
      within '.answers-list' do
        click_on 'Edit answer'

        fill_in 'Body', with: 'test answer'
        click_on 'Save'

        expect(page).to_not have_content answer.body
        expect(page).to have_content 'test answer'
        expect(page).to_not have_selector 'textarea'
      end
    end

    scenario 'tries to edit his answer for question with incorrect attributes' do
      visit_question_page(question, user)
      within '.answers-list' do
        click_on 'Edit answer'

        fill_in 'Body', with: ''
        click_on 'Save'

        expect(page).to have_content answer.body
        expect(page).to have_content "Body can't be blank"
      end
    end

    scenario 'tries to edit not owned him answer' do
      visit_question_page(question, another_user)

      expect(page).to_not have_link 'Edit answer'
    end

  end


end
