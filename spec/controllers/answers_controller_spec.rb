# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { create(:question) }
  let(:user) { create(:user) }
  let(:answer) { create(:answer) }
  let(:invalid_user) { create(:user) }

  describe 'POST #create' do
    before { login(user) }

    context 'with valid attributes' do
      it 'saves a new answer in the database' do
        expect { post :create, params: { answer: attributes_for(:answer), question_id: question } }
          .to change(question.answers, :count).by(1)
      end

      it 'redirects to show question view' do
        post :create, params: { answer: attributes_for(:answer), question_id: question }
        expect(response).to redirect_to assigns(:question)
      end
    end

    context 'with invalid attributes' do
      it 'does not save a new answer in the database' do
        expect do
          post :create,
               params: { answer: attributes_for(:answer, :invalid),
                         question_id: question }
        end.to_not change(question.answers, :count)
      end

      it 'redirects to show question view' do
        post :create, params: { answer: attributes_for(:answer, :invalid), question_id: question }
        expect(response).to render_template :show
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'author of the answer tries to delete the answer' do
      valid_user = answer.user
      login(valid_user)

      expect { delete :destroy, params: { id: answer } }
        .to change(Answer, :count).by(-1)
    end

    it 'not the author of the answer tries to delete the answer' do
      answer
      login(invalid_user)

      expect { delete :destroy, params: { id: answer } }
        .to change(Answer, :count).by(0)
    end
  end
end
