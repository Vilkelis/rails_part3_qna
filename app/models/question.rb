# frozen_string_literal: true

# Question
class Question < ApplicationRecord
  has_many :answers, dependent: :destroy
  belongs_to :user

  validates :title, :body, presence: true
  validates :title, uniqueness: { case_sensitive: false }
end
