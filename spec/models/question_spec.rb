# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Question, type: :model do
  describe 'associations' do
    it { should have_many(:answers).dependent(:destroy) }
    it { should belong_to(:user) }
  end

  describe 'validations' do
    subject { create(:question) }

    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:body) }
    it { should validate_uniqueness_of(:title).case_insensitive }
  end

  describe 'attachments' do
    it 'have many attached file' do
      expect(Question.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
    end
  end
end
