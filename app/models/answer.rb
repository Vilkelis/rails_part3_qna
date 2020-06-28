# frozen_string_literal: true

# Answers for a question
class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user

  validates :body, presence: true

  default_scope { order(best: :desc, created_at: :desc) }
end
