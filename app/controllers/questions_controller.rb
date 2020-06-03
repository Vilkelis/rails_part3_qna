# frozen_string_literal: true

# Questions controller
class QuestionsController < ApplicationController
  before_action :load_question, only: [:show]

  def new
    @question = Question.new
  end

  def create
    @question = Question.new(question_params)
    if @question.save
      redirect_to @question, notice: 'Question created.'
    else
      render :new
    end
  end

  def show; end

  private

  def question_params
    params.require(:question).permit(:title, :body)
  end

  def load_question
    @question = Question.find(params[:id])
  end
end
