# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Answer, type: :model do
  describe 'associations' do
    it { should belong_to(:question) }
    it { should belong_to(:user) }
  end

  describe 'validations' do
    it { should validate_presence_of(:body) }
  end

  describe 'the best attribute' do
    subject(:question_with_answers) { create(:question_with_answers) }
    subject(:best_answer) { create(:answer, question: question_with_answers, best: true ) }
    subject(:answer_for_best) { question_with_answers.answers.where(best: false).first }

    context 'user set the best to true' do
      before do
        best_answer
        answer_for_best.make_best
      end

      it 'the best attribute sets to true' do
        answer_for_best.reload
        expect(answer_for_best.best).to be_truthy
      end

      it 'other question answers have the best attribute falsey' do
        question_with_answers.answers.reload
        question_with_answers.answers.each do |answer|
          unless answer_for_best.id == answer.id
            expect(answer.best).to be_falsey
          end
        end
      end
    end
  end
end
