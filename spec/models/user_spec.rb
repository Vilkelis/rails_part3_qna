# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:email) }
    it { should validate_presence_of(:password) }
  end

  describe '#author_of' do
    let(:question) { create(:question) }
    let(:invalid_user) { create(:user) }

    context 'object without user_id attribute' do
      it 'user is invalid author' do
        object = 'test'
        expect(invalid_user).to_not be_author_of(object)
      end
    end

    context 'object with user_id attribute' do
      it 'user is valid author' do
        valid_user = question.user
        expect(valid_user).to be_author_of(question)
      end

      it 'user is invalid author' do
        expect(invalid_user).to_not be_author_of(question)
      end
    end
  end
end
