# frozen_string_literal: true

# Answers controller
class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :load_question, only: %i[new create]
  before_action :load_answer, only: %i[update destroy best delete_file]

  def create
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user
    flash.now[:notice] = 'Answer created.' if @answer.save
  end

  def destroy
    if current_user.author_of?(@answer)
      flash.now[:notice] = 'Answer deleted successfully.' if @answer.destroy
    else
      flash.now[:alert] = 'You can delete only your own answers.'
    end
  end

  def update
    if current_user.author_of?(@answer)
      flash.now[:notice] = 'Answer updated.' if @answer.update(answer_params)
    else
      flash.now[:alert] = 'You can update only your own answers.'
    end
  end

  def best
    if current_user.author_of?(@answer.question)
      @answer.make_best
    else
      flash.now[:alert] = 'You cannot set answer as the best, because you are not the question author.'
    end
  end

  private

  def answer_params
    params.require(:answer).permit(:body, files: [])
  end

  def load_question
    @question = Question.find(params[:question_id])
  end

  def load_answer
    @answer = Answer.find(params[:id])
  end
end
