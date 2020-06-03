# frozen_string_literal: true

# Answers controller
class AnswersController < ApplicationController
  before_action :load_question, only: %i[new create]

  def new
    @answer = @question.answers.new
  end

  def create
    @answer = @question.answers.new(answer_params)
    if @answer.save
      redirect_to @question, notice: 'Answer created.'
    else
      render :new
    end
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end

  def load_question
    @question = Question.find(params[:question_id])
  end
end
