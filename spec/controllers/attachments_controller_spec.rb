# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AttachmentsController, type: :controller do
  let(:invalid_user) { create(:user) }
  let(:question_with_files) { create(:question, :with_files) }
  let(:answer_with_files) { create(:answer, :with_files) }

  describe 'DELETE #destroy' do
    context 'author of the question' do
      before { login(question_with_files.user) }

      it 'deletes file' do
        files_count = delete_question_files(question_with_files)
        expect(question_with_files.files.count).to be_zero
      end
    end

    context 'not author of the question' do
      before { login(invalid_user) }

      it 'deletes file' do
        files_count = delete_question_files(question_with_files)
        expect(question_with_files.files.count).to eq files_count
      end
    end

    context 'author of the answer' do
      before { login(answer_with_files.user) }

      it 'deletes file' do
        files_count = delete_answer_files(answer_with_files)
        expect(answer_with_files.files.count).to be_zero
      end
    end

    context 'not author of the answer' do
      before { login(invalid_user) }

      it 'deletes file' do
        files_count = delete_answer_files(answer_with_files)
        expect(answer_with_files.files.count).to eq files_count
      end
    end

    context 'not logged in user' do
      it 'deletes question file' do
        files_count = delete_question_files(question_with_files)
        expect(question_with_files.files.count).to eq files_count
      end

      it 'deletes answer file' do
        files_count = delete_answer_files(answer_with_files)
        expect(answer_with_files.files.count).to eq files_count
      end
    end
  end
end