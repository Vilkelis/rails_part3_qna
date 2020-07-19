# frozen_string_literal: true

require 'rails_helper'

feature 'Only authenticated user can create question', '
  Only authenticated user can create new question and view created question after creation
' do
  describe 'Authenticated user', js: true do
    given(:user) { create(:user) }

    background do
      login(user)
      go_to_new_question_form
    end

    scenario 'tries to create new question with correct attributes' do
      fill_in 'Title', with: 'Test question title'
      fill_in 'Body', with: 'Test question body'
      click_on 'Create'

      expect(page).to have_content 'Question created.'
      expect(page).to have_content 'Test question title'
      expect(page).to have_content 'Test question body'
    end

    scenario 'tries to create new question with incorrect attributes' do
      fill_in 'Title', with: 'Test question title'
      click_on 'Create'

      expect(page).to have_content "Body can't be blank"
    end

    scenario 'asks a question with attached files' do
      fill_in 'Title', with: 'Test question title'
      fill_in 'Body', with: 'Test question body'
      attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb","#{Rails.root}/spec/spec_helper.rb"]

      click_on 'Create'

      expect(page).to have_link "rails_helper.rb"
      expect(page).to have_link "spec_helper.rb"
    end
  end

  scenario 'Unauthenticated user tries to create new question with correct attributes', js: true do
    go_to_new_question_form

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
