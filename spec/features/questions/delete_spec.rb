# frozen_string_literal: true

require 'rails_helper'

feature 'Only author can delete your own question', "
Author can delete your own question,
but can't delete not owned him questions.
" do
  given(:another_user) { create(:user) }
  given(:question) { create(:question) }

  describe 'Authenticated user' do
    scenario 'tries to delete your own question' do
      visit_question_page(question, question.user)
      click_on 'Delete question'

      expect(page).to have_no_content question.title
      expect(page).to have_content 'Question deleted successfully.'
    end

    scenario 'tries to delete not owned him question' do
      visit_question_page(question, another_user)

      expect(page).to have_no_content 'Delete question'
    end
  end

  scenario 'Unauthenticated user tries to delete question' do
    visit_question_page(question)

    expect(page).to have_no_content 'Delete question'
  end
end
