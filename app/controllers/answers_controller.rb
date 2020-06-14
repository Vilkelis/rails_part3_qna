# frozen_string_literal: true

# Answers controller
class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :load_question, only: %i[new create]
  before_action :load_answer, only: %i[destroy]

  def new
    @answer = @question.answers.new
  end

  def create
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user
    if @answer.save
      redirect_to @question, notice: 'Answer created.'
    else
      render '/questions/show'
    end
  end

  def destroy
    if current_user != @answer.user
      redirect_to questions_path, alert: 'You can delete only your own answers.'
    else
      @answer.destroy!
      redirect_to questions_path, notice: 'Answer deleted successfully.'
    end
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end

  def load_question
    @question = Question.find(params[:question_id])
  end

  def load_answer
    @answer = Answer.find(params[:id])
  end
end
