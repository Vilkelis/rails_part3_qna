# frozen_string_literal: true

# Answers for a question
class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user

  validates :body, presence: true

  after_save :after_save_update_best_for_answers

  default_scope { order(best: :desc, created_at: :desc) }

  private

  def after_save_update_best_for_answers
    question.answers.where.not(id: id).update(best: false) if best?
  end
end
