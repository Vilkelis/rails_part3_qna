# frozen_string_literal: true

require 'rails_helper'

feature 'Only author of answer can add and delete files on your own answer', "
Author can attache files to your own answer,
but can't attache files to not owned him answers.
Also only author of answer can remove attached files.
" do
  given(:another_user) { create(:user) }
  given(:answer) { create(:answer, :with_files) }

  describe 'Authenticated user', js: true do

    scenario 'tries to add files to owned him answer' do
      visit_question_page(answer.question, answer.user)

      within ".answers-list > [data-answer='#{answer.id}']" do
        click_on "Edit answer"

        attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb","#{Rails.root}/spec/spec_helper.rb"]

        click_on 'Save'

        expect(page).to have_link "rails_helper.rb"
        expect(page).to have_link "spec_helper.rb"
      end
    end

    scenario 'tries to delete file on owned him answer' do
      visit_question_page(answer.question, answer.user)

      within ".answers-list > [data-answer='#{answer.id}']" do
        expect(page).to have_link 'Delete file'

        answer.files.each do |file|
          within "#Answer-#{answer.id}-file-#{file.id}" do
            click_on 'Delete file'
          end
          expect(page).to have_no_selector  "#Answer-#{answer.id}-file-#{file.id}"
        end

        expect(page).to have_no_link 'Delete file'
      end
    end

    scenario 'tries to delete file on not owned him answer' do
      visit_question_page(answer.question, another_user)

      within '.answers-list' do
        expect(page).to have_no_link 'Delete file'
      end
    end
  end

  scenario 'Unauthenticated user tries to delete attached to answer files' do
    visit_question_page(answer.question)

    within '.answers-list' do
      expect(page).to have_no_link 'Delete file'
    end
  end
end
