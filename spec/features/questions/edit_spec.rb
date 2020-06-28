# frozen_string_literal: true

require 'rails_helper'

feature 'Only author can edit your own question', "
Author can edit your own question,
but can't edit not owned him questions.
" do
  given(:another_user) { create(:user) }
  given(:question) { create(:question) }

  describe 'Authenticated user', js: true do
    scenario 'tries to edit your own question' do
      visit_question_page(question, question.user)
      within '.question' do
        click_on 'Edit question'

        fill_in 'Title', with: 'Test title'
        fill_in 'Body', with: 'Test body'

        click_on 'Save'
      end

      expect(page).to have_content 'Test title'
      expect(page).to have_content 'Test body'
    end

    scenario 'tries to edit not owned him question' do
      visit_question_page(question, another_user)

      expect(page).to have_no_content 'Edit question'
    end
  end

  scenario 'Unauthenticated user tries to edit question' do
    visit_question_page(question)

    expect(page).to have_no_content 'Edit question'
  end
end
