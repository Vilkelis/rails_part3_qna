# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { create(:question) }

  describe 'GET #new' do
    before { get :new, params: { question_id: question } }

    it 'assigns new answer to @answer' do
      expect(assigns(:answer)).to be_a_new(Answer).with(question_id: question.id)
    end

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
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

      it 'redirects to new answer view' do
        post :create, params: { answer: attributes_for(:answer, :invalid), question_id: question }
        expect(response).to render_template :new
      end
    end
  end
end
