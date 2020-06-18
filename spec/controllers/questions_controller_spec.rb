# frozen_string_literal: true

require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:question) { create(:question) }
  let(:questions) { create_list(:question, 4) }
  let(:user) { create(:user) }
  let(:invalid_user) { create(:user) }

  describe 'GET #new' do
    before { login(user) }

    before { get :new }

    it 'assigns new question to @question' do
      expect(assigns(:question)).to be_a_new(Question)
    end

    it 'question user equals to logged user' do
      expect(assigns(:question).user_id).to eq(user.id)
    end

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
    before { login(user) }

    context 'with valid attributes' do
      it 'saves a new question in the database' do
        expect { post :create, params: { question: attributes_for(:question) } }
          .to change(Question, :count).by(1)
      end

      it 'question user equals to logged user' do
        post :create, params: { question: attributes_for(:question) }
        expect(assigns(:question).user_id).to eq(user.id)
      end

      it 'redirects to show view' do
        post :create, params: { question: attributes_for(:question) }
        expect(response).to redirect_to assigns(:question)
      end
    end

    context 'with invalid attributes' do
      it 'does not save the question' do
        expect { post :create, params: { question: attributes_for(:question, :invalid) } }
          .to_not change(Question, :count)
      end

      it 're-renders new view' do
        post :create, params: { question: attributes_for(:question, :invalid) }
        expect(response).to render_template :new
      end
    end
  end

  describe 'GET #show' do
    before { get :show, params: { id: question } }

    it 'assigns the requested question to @question' do
      expect(assigns(:question)).to eq question
    end

    it 'renders show view' do
      expect(response).to render_template :show
    end
  end

  describe 'GET #index' do
    before { get :index }

    it 'assigns questions to @questions' do
      expect(assigns(:questions)).to eq questions
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end

  describe 'DELETE #destroy' do
    context 'author of the question' do
      before { login(question.user) }

      it 'deletes question from the database' do
        expect { delete :destroy, params: { id: question } }
          .to change(Question, :count).by(-1)
      end

      it 'redirects to questions list' do
        delete :destroy, params: { id: question }
        expect(response).to redirect_to questions_path
      end
    end

    context 'not the author of the question' do
      before do
        question
        login(invalid_user)
      end

      it 'tries to delete the question' do
        expect { delete :destroy, params: { id: question } }
          .to change(Question, :count).by(0)
      end

      it 'redirects to question page' do
        delete :destroy, params: { id: question }
        expect(response).to redirect_to question
      end
    end
  end
end
