# frozen_string_literal: true

require 'rails_helper'

feature 'Only answer author can delete your own answer on question', "
Author can delete your own answers for questions,
but can't delete not owned him answers.
" do
  given(:another_user) { create(:user) }
  given!(:answer) { create(:answer) }

  describe 'Authenticated user' do
    scenario 'tries to delete your own answer' do
      visit_question_page(answer.question, answer.user)
      click_on 'Delete answer'

      expect(page).to have_no_content answer.body
      expect(page).to have_content 'Answer deleted successfully.'
    end

    scenario 'tries to delete not owned him question' do
      visit_question_page(answer.question, another_user)

      expect(page).to have_no_content 'Delete answer'
    end
  end

  scenario 'Unauthenticated user tries to delete answer' do
    visit_question_page(answer.question)

    expect(page).to have_no_content 'Delete answer'
  end
end
