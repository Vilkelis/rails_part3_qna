# frozen_string_literal: true

require 'rails_helper'

feature 'Only author can delete your own question', "
Author can delete your own question,
but can't delete not owned him questions.
" do
  given(:user) { create(:user) }
  given(:another_user) { create(:user) }

  describe 'Authenticated user' do
    scenario 'tries to delete your own question' do
      login(user)
      go_to_new_question_form
      create_question
      click_on 'Delete question'

      expect(page).to have_content 'Question deleted successfully.'
    end

    scenario 'tries to delete not owned him question' do
      login(another_user)
      go_to_new_question_form
      create_question
      logout

      login(user)
      click_on 'Test question title'
      click_on 'Delete question'

      expect(page).to have_content 'You can delete only your own questions.'
    end
  end

  scenario 'Unauthenticated user tries to delete question' do
    login(user)
    go_to_new_question_form
    create_question
    logout
    visit root_path
    click_on 'Test question title'

    click_on 'Delete question'

    expect(page).to have_content 'You need to sign in or sign up before continuing'
  end
end
