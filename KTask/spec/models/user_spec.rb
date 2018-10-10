# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  context 'パラメータが正しい場合' do
    it 'ユーザが有効' do
      user = build(:user)
      expect(user).to be_valid
    end
  end

  context 'パラメータが正しくない場合' do
    it 'ユーザの名前がない' do
      user = build(:user, name: nil)
      expect(user).not_to be_valid
    end

    it 'ユーザのメールがない' do
      user = build(:user, email: nil)
      expect(user).not_to be_valid
    end

    it 'ユーザのパスワードがない' do
      user = build(:user, password: nil)
      expect(user).not_to be_valid
    end

    it 'ユーザのパスワードが12字以上' do
      user = build(:user, password: 'a' * 13)
      expect(user).not_to be_valid
    end
  end
end
