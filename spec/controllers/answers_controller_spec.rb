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

      it 'user of created answer equals logged user' do
        post :create, params: { answer: attributes_for(:answer), question_id: question }
        expect(assigns(:answer).user_id).to eq(user.id)
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
    context 'author of the answer' do
      before { login(answer.user) }

      it 'deletes the answer from the database' do
        expect { delete :destroy, params: { id: answer } }
          .to change(Answer, :count).by(-1)
      end

      it 'resirects to the question page' do
        delete :destroy, params: { id: answer }
        expect(response).to redirect_to answer.question
      end
    end

    context 'not the author of the answer' do
      before do
        answer
        login(invalid_user)
      end

      it 'does not delete the answer from the database' do
        expect { delete :destroy, params: { id: answer } }
          .to_not change(Answer, :count)
      end

      it 'redirects to the question page' do
        delete :destroy, params: { id: answer }
        expect(response).to redirect_to answer.question
      end
    end
  end
end
