require 'rails_helper'

RSpec.describe User, type: :model do

  context 'When there is no validation error.' do
    let(:user) { create(:user) }
    it 'can create a user' do
      expect(user).to be_valid
    end
  end

  context 'When the length of name is less than max length' do
    let(:user) { create(:user, name: 'n' * 32) }
    it 'can create a user' do
      expect(user).to be_valid
    end
  end

  context 'When the length of name is more than max length' do
    let(:user) { User.new(name: 'hoge' * 33, email: 'hoge@fuga.com', role: 1) }
    it 'name cannot be more than max length' do
      expect(user).not_to be_valid
      expect(user.errors[:name]).to be_present
    end
  end

  context 'When the name is nil' do
    let(:user) { User.new(email: 'hoge@fuga.com', role: 1) }
    it 'name cannot be nil' do
      expect(user).not_to be_valid
      expect(user.errors[:name]).to be_present
    end
  end

  context 'When the format of email is invalid' do
    let(:user) { User.new(name: 'hoge', email: 'hoge', role: 1) }
    it 'email cannot be invalid format' do
      expect(user).not_to be_valid
      expect(user.errors[:email]).to be_present
    end
  end

  context 'When the email is nil' do
    let(:user) { User.new(name: 'hoge', role: 1) }
    it 'email cannot be nil' do
      expect(user).not_to be_valid
      expect(user.errors[:email]).to be_present
    end
  end

  context 'When the email is already registered' do
    let!(:user) { create(:user) }
    let(:user2) { User.new(name: 'hoge', email: 'hoge@fuga.com') }
    it 'email should be uniq' do
      expect(user2).not_to be_valid
      expect(user2.errors[:email]).to be_present
    end
  end

  context 'When role is nil' do
    let(:user) { User.new(name: 'hoge', email: 'hoge@fuga.com') }
    it 'role cannot be nil' do
      expect(user).not_to be_valid
      expect(user.errors[:role]).to be_present
    end
  end
end
