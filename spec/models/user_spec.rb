# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:email) }
    it { should validate_presence_of(:password) }
  end

  describe 'check author of' do
    let(:question) { create(:question) }
    let(:answer) { create(:answer) }
    let(:invalid_user) { create(:user) }

    context 'question' do
      it 'user is valid author' do
        valid_user = question.user
        expect(valid_user.author_of?(question)).to be_truthy
      end

      it 'user is invalid author' do
        expect(invalid_user.author_of?(question)).to be_falsey
      end
    end

    context 'answer' do
      it 'user is valid author' do
        valid_user = answer.user
        expect(valid_user.author_of?(answer)).to be_truthy
      end

      it 'user is invalid author' do
        expect(invalid_user.author_of?(answer)).to be_falsey
      end
    end
  end
end
