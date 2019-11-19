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
    let(:user) { User.new(name: 'hoge' * 33, email: 'hoge@example.com', role: 1) }
    it 'name cannot be more than max length' do
      expect(user).not_to be_valid
      expect(user.errors[:name]).to be_present
    end
  end

  context 'When the name is nil' do
    let(:user) { User.new(email: 'hoge@example.com', role: 1) }
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
    let(:user2) { User.new(name: 'hoge', email: 'hoge@example.com') }
    it 'email should be uniq' do
      expect(user2).not_to be_valid
      expect(user2.errors[:email]).to be_present
    end
  end

  context 'When role is nil' do
    let(:user) { User.new(name: 'hoge', email: 'hoge@example.com') }
    it 'role cannot be nil' do
      expect(user).not_to be_valid
      expect(user.errors[:role]).to be_present
    end
  end

  context 'When trying to delete an user which is only one admin user' do
    let(:user) { create(:admin_user) }
    it 'cannot be destroyed' do
      expect(user.destroy).to be_falsey
    end
  end

  context 'When trying to change role of an user which is only one admin user' do
    let(:user) { create(:admin_user) }
    it 'role cannot be changed' do
      expect { user.general! }.to raise_error(ActiveRecord::RecordInvalid)
      expect(user.errors[:role]).to be_present
      expect(user.reload.role).to eq 'admin'
    end
  end
end
