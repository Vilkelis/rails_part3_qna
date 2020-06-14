# frozen_string_literal: true

# Questions controller
class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]
  before_action :load_question, only: %i[show destroy]

  def index
    @questions = Question.all
  end

  def new
    @question = Question.new
  end

  def create
    @question = Question.new(question_params)
    @question.user = current_user
    if @question.save
      redirect_to @question, notice: 'Question created.'
    else
      render :new
    end
  end

  def show
    @answer = @question.answers.new
  end

  def destroy
    if current_user != @question.user
      redirect_to @question, alert: 'You can delete only your own questions.'
    else
      @question.destroy!
      redirect_to questions_path, notice: 'Question deleted successfully.'
    end
  end

  private

  def question_params
    params.require(:question).permit(:title, :body)
  end

  def load_question
    @question = Question.find(params[:id])
  end
end
