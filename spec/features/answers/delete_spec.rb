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
      login(answer.user)
      visit root_path
      click_on answer.question.title

      click_on 'Delete answer'

      expect(page).to have_content 'Answer deleted successfully.'
    end

    scenario 'tries to delete not owned him question' do
      login(another_user)
      visit root_path
      click_on answer.question.title

      expect(page).to have_no_content 'Delete answer'
    end
  end

  scenario 'Unauthenticated user tries to delete answer' do
    visit root_path
    click_on answer.question.title

    expect(page).to have_no_content 'Delete answer'
  end
end
