# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { create(:question) }
  let(:question_with_answers) { create(:question_with_answers) }
  let(:user) { create(:user) }
  let(:answer) { create(:answer) }
  let(:invalid_user) { create(:user) }

  describe 'POST #create' do
    before { login(user) }

    context 'with valid attributes' do
      it 'saves a new answer in the database' do
        expect { post :create, params: { answer: attributes_for(:answer), question_id: question, format: :js } }
          .to change(question.answers, :count).by(1)
      end

      it 'render create.js' do
        post :create, params: { answer: attributes_for(:answer), question_id: question, format: :js }
        expect(response).to render_template :create
      end

      it 'user of created answer equals logged user' do
        post :create, params: { answer: attributes_for(:answer), question_id: question, format: :js }
        expect(assigns(:answer).user_id).to eq(user.id)
      end
    end

    context 'with invalid attributes' do
      it 'does not save a new answer in the database' do
        expect do
          post :create,
               params: { answer: attributes_for(:answer, :invalid),
                         question_id: question,
                         format: :js }
        end.to_not change(question.answers, :count)
      end

      it 'renders create.js' do
        post :create, params: { answer: attributes_for(:answer, :invalid), question_id: question, format: :js }
        expect(response).to render_template :create
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'author of the answer' do
      before { login(answer.user) }

      it 'deletes the answer from the database' do
        expect { delete :destroy, params: { id: answer }, format: :js }
          .to change(Answer, :count).by(-1)
      end

      it 'renders destroy.js' do
        delete :destroy, params: { id: answer }, format: :js
        expect(response).to render_template :destroy
      end
    end

    context 'not the author of the answer' do
      before do
        answer
        login(invalid_user)
      end

      it 'does not delete the answer from the database' do
        expect { delete :destroy, params: { id: answer }, format: :js }
          .to_not change(Answer, :count)
      end

      it 'renders destroy.js' do
        delete :destroy, params: { id: answer }, format: :js
        expect(response).to render_template :destroy
      end
    end
  end

  describe 'PATCH #update' do

    context 'author of the answer' do
      before { login(answer.user) }
      context 'with valid atributes' do
        before { patch :update, params: { id: answer, answer: { body: 'test answer body' } }, format: :js }
        it 'changes answer attributes' do
          answer.reload

          expect(answer.body).to eq 'test answer body'
        end

        it 'renders update view' do
          expect(response).to render_template :update
        end
      end

      context 'with invalid atributes' do
        before { patch :update, params: { id: answer, answer: { body: '' } }, format: :js }

        it 'does not change answer attributes' do
          old_body = answer.body
          answer.reload

          expect(answer.body).to eq old_body
        end

        it 'renders update view' do
          expect(response).to render_template :update
        end
      end
    end

    context 'not the author of the answer' do
      before do
        answer
        login(invalid_user)
        patch :update, params: { id: answer, answer: { body: 'test answer body' } }, format: :js
      end

      it 'does not change the answer' do
        old_body = answer.body
        answer.reload

        expect(answer.body).to eq old_body
      end

      it 'renders update view' do
        expect(response).to render_template :update
      end
    end
  end

  describe 'PATCH #best' do

    let(:answer_for_best) { question_with_answers.answers.first }
    let(:answer_the_best) { question_with_answers.answers.last }

    context 'author of the question' do
      before do
        answer_the_best.update( best: true)
        login(question_with_answers.user)
        patch :best, params: { id: answer_for_best }, format: :js
      end

      it 'changes answer best attribute to true' do
        answer_for_best.reload
        expect(answer_for_best.best).to be_truthy
      end

      it 'changes answer best attribute for other answers to false' do
        question_with_answers.answers.reload
        question_with_answers.answers.each do |answer|
          unless answer_for_best.id == answer.id
            expect(answer.best).to be_falsey
          end
        end
      end

      it 'renders best view' do
        expect(response).to render_template :best
      end
    end

    context 'not the author of the question' do
      before do
        answer_the_best.update( best: true)
        login(invalid_user)
        patch :best, params: { id: answer_for_best }, format: :js
      end

      it 'does not change answers best attributes' do
        question_with_answers.answers.reload
        question_with_answers.answers.each do |answer|
          old_best = answer.best
          answer.reload
          expect(answer.best).to eq old_best
        end
      end

      it 'renders best view' do
        expect(response).to render_template :best
      end
    end

    context 'unauthorized user' do
      before do
        answer_the_best.update( best: true)
        login(invalid_user)
        patch :best, params: { id: answer_for_best }, format: :js
      end

      it 'does not change answers best attributes' do
        question_with_answers.answers.reload
        question_with_answers.answers.each do |answer|
          old_best = answer.best
          answer.reload
          expect(answer.best).to eq old_best
        end
      end

      it 'renders best view' do
        expect(response).to render_template :best
      end
    end

  end

end
