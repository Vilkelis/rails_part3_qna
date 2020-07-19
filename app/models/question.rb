# frozen_string_literal: true

# Question
class Question < ApplicationRecord
  has_many :answers, dependent: :destroy

  has_many_attached :files

  belongs_to :user

  validates :title, :body, presence: true
  validates :title, uniqueness: { case_sensitive: false }
end
