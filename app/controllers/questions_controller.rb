# frozen_string_literal: true

# Questions controller
class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]
  before_action :load_question, only: %i[show update destroy delete_file]

  def index
    @questions = Question.all
  end

  def new
    @question = Question.new
    @question.user = current_user
  end

  def create
    @question = Question.new(question_params)
    @question.user = current_user
    if @question.save
      redirect_to @question, notice: 'Question created.'
    end
  end

  def show
    @answer = @question.answers.new
  end

  def destroy
    if current_user.author_of?(@question)
      @question.destroy!
      redirect_to questions_path, notice: 'Question deleted successfully.'
    else
      redirect_to @question, alert: 'You can delete only your own questions.'
    end
  end

  def update
    flash.clear
    if current_user.author_of?(@question)
      flash.now[:notice] = 'Question updated.' if @question.update(question_params)
    else
      flash.now[:alert] = 'You can update only your own questions.'
    end
  end

  def delete_file
    if current_user.author_of?(@question)
      @file = @question.files.find_by_id(params[:file])
      @file.purge
      if !@file.persisted?
        flash.now[:notice] = "File #{@file.filename.to_s} deleted."
      else
        flash.now[:alert] = "Can't delete file #{@file.filename.to_s}."
      end
    else
      flash.now[:alert] = 'You can delete attached files from only your own questions.'
    end
  end

  private

  def question_params
    params.require(:question).permit(:title, :body, files: [])
  end

  def load_question
    @question = Question.with_attached_files.find(params[:id])
  end
end
