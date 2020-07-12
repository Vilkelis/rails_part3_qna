# frozen_string_literal: true

require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:question) { create(:question) }
  let(:questions) { create_list(:question, 4) }
  let(:user) { create(:user) }
  let(:invalid_user) { create(:user) }
  let(:question_with_files) { create(:question, :with_files) }

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
        expect { post :create, params: { question: attributes_for(:question), format: :js } }
          .to change(Question, :count).by(1)
      end

      it 'user of created question equals to logged user' do
        post :create, params: { question: attributes_for(:question), format: :js  }
        expect(assigns(:question).user_id).to eq(user.id)
      end

      it 'redirects to show view' do
        post :create, params: { question: attributes_for(:question), format: :js  }
        expect(response).to redirect_to assigns(:question)
      end
    end

    context 'with invalid attributes' do
      it 'does not save the question' do
        expect { post :create, params: { question: attributes_for(:question, :invalid), format: :js } }
          .to_not change(Question, :count)
      end

      it 'renders create.js' do
        post :create, params: { question: attributes_for(:question, :invalid), format: :js }
        expect(response).to render_template :create
      end
    end
  end

  describe 'PATCH #update' do

    context 'question author tries to update question' do
      before { login(question.user) }

      context 'with valid atributes' do
        before { patch :update, params: { id: question, question: { title: 'Test title', body: 'Test body' }, format: :js } }

        it 'changes question attributes' do
          question.reload

          expect(question.title).to eq 'Test title'
          expect(question.body).to eq 'Test body'
        end

        it 'renders update view' do
          expect(response).to render_template :update
        end
      end

      context 'with invalid atributes' do
        before { patch :update, params: { id: question, question: { title: '', body: '' }, format: :js } }

        it 'does not change question attributes' do
          old_body = question.body
          old_title = question.title
          question.reload

          expect(question.title).to eq old_title
          expect(question.body).to eq old_body
        end

        it 'renders update view' do
          expect(response).to render_template :update
        end
      end
    end

    context 'not the question author tries to update question' do
      before do
        login(invalid_user)
        patch :update, params: { id: question, question: { title: 'Test title', body: 'Test body' }, format: :js }
      end

      it 'does not change question attributes' do
        old_body = question.body
        old_title = question.title
        question.reload

        expect(question.title).to eq old_title
        expect(question.body).to eq old_body
      end

      it 'renders update view' do
        expect(response).to render_template :update
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
          .to_not change(Question, :count)
      end

      it 'redirects to question page' do
        delete :destroy, params: { id: question }
        expect(response).to redirect_to question
      end
    end
  end

  describe 'DELETE #delete_file' do
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

    context 'not logged in user' do
      it 'deletes file' do
        files_count = delete_question_files(question_with_files)
        expect(question_with_files.files.count).to eq files_count
      end
    end
  end
end
