# frozen_string_literal: true

require 'rails_helper'

feature 'Author of question can choose the best answer', '
  User can choose one and only one answer as best answer for your own question.
' do

  given(:another_user) { create(:user) }
  given(:question) { create(:question_with_answers) }
  given(:best_answer) { create(:answer, question: question, best: true ) }

  describe 'Authenticated user: owner of question', js: true do
    before do
      best_answer
      visit_question_page(question, question.user)
    end

    scenario 'each answer has link to choose the answer as the best but the best answer does not have the link' do
      question.answers.each do |answer|
        within ".answers-list > [data-answer='#{answer.id}']" do
          if answer.best?
            expect(page).to_not have_link 'Choose as the best'
            expect(page).to have_text 'The Best!'
          else
            expect(page).to have_link 'Choose as the best'
            expect(page).to_not have_text 'The Best!'
          end
        end
      end
    end

    scenario 'The best answer is displayed first in the answers list' do
      within ".answers-list > [data-answer]:first-of-type" do
        expect(page).to have_text 'The Best!'
      end
    end

    scenario 'tries to choose the best answer to your own question' do
      not_best_answer = question.answers.where(best: false).first

      within ".answers-list > li[data-answer='#{not_best_answer.id}']" do
        click_on 'Choose as the best'
      end

      within ".answers-list > li[data-answer='#{not_best_answer.id}']" do
        expect(page).to_not have_link 'Choose as the best'
        expect(page).to have_text 'The Best!'
      end

      question.answers.each do |answer|
        within ".answers-list > li[data-answer='#{answer.id}']" do
          unless not_best_answer.id == answer.id
            expect(page).to have_link 'Choose as the best'
            expect(page).to_not have_text 'The Best!'
          end
        end
      end

    end
  end

  describe 'Authenticated user: not owner of question', js: true do
    before do
      best_answer
      visit_question_page(question, another_user)
    end

    scenario 'does not see the Choose as the best link and sees the best answer marker' do
      question.answers.each do |answer|
        within ".answers-list > [data-answer='#{answer.id}']" do
          expect(page).to_not have_link 'Choose as the best'
          if answer.best?
            expect(page).to have_text 'The Best!'
          end
        end
      end
    end

    scenario 'The best answer is displayed first in the answers list' do
      within ".answers-list > [data-answer]:first-of-type" do
        expect(page).to have_text 'The Best!'
      end
    end
  end

  describe 'Unauthenticated user:' do
    before do
      best_answer
      visit_question_page(question)
    end

    scenario 'does not see the Choose as the best link and sees the best answer marker' do
      question.answers.each do |answer|
        within ".answers-list > [data-answer='#{answer.id}']" do
          expect(page).to_not have_link 'Choose as the best'
          if answer.best?
            expect(page).to have_text 'The Best!'
          end
        end
      end
    end

    scenario 'The best answer is displayed first in the answers list' do
      within ".answers-list > [data-answer]:first-of-type" do
        expect(page).to have_text 'The Best!'
      end
    end
  end

end
