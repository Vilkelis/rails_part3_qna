# frozen_string_literal: true

# Answers for a question
class Answer < ApplicationRecord
  has_many_attached :files

  belongs_to :question
  belongs_to :user

  validates :body, presence: true

  default_scope { order(best: :desc, created_at: :desc) }

  def make_best
    transaction do
      question.answers.where.not(id: id).each{ |record| record.update!(best: false) }
      update!(best: true)
    end
  end
end
