# frozen_string_literal: true

require 'rails_helper'

feature 'Only author of question can add and delete files on your own question', "
Author can attache files to your own question,
but can't attache files to not owned him questions.
Also only author of question can remove attached files.
" do
  given(:another_user) { create(:user) }
  given(:question) { create(:question) }
  given(:question_with_files) { create(:question,:with_files) }

  describe 'Authenticated user', js: true do
    scenario 'tries to add files to owned him question' do
      visit_question_page(question, question.user)
      within '.question' do
        click_on "Edit question"

        attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb","#{Rails.root}/spec/spec_helper.rb"]

        click_on 'Save'

        expect(page).to have_link "rails_helper.rb"
        expect(page).to have_link "spec_helper.rb"
      end
    end

    scenario 'tries to delete file on owned him question' do
      visit_question_page(question_with_files, question_with_files.user)

      within '.question' do
        expect(page).to have_link 'Delete file'

        question_with_files.files.each do |file|
          within "#question-file-#{file.id}" do
            click_on 'Delete file'
          end

          expect(page).to have_no_selector  "#question-file-#{file.id}"
        end

        expect(page).to have_no_link 'Delete file'
      end
    end

    scenario 'tries to delete file on not owned him question' do
      visit_question_page(question_with_files, another_user)

      within '.question' do
        expect(page).to have_no_link 'Delete file'
      end
    end
  end

  scenario 'Unauthenticated user tries to edit question' do
    visit_question_page(question_with_files)

    within '.question' do
      expect(page).to have_no_link 'Delete file'
    end
  end
end
