# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  context 'パラメータが正しい場合' do
    it 'ユーザが有効' do
      user = build(:user)
      expect(user).to be_valid
    end

    it 'ユーザの名前が30字以内' do
      user = build(:user, name: 'あ' * 30)
      expect(user).to be_valid
    end

    it 'メールアドレスが50字以内' do
      user = build(:user, email: 'a' * 40 + '@gmail.com')
      expect(user).to be_valid
    end

    it 'ユーザのパスワードが12字以内' do
      user = build(:user, password: 'a' * 12)
      expect(user).to be_valid
    end
  end

  context 'パラメータが正しくない場合' do
    it 'ユーザの名前がない' do
      user = build(:user, name: nil)
      expect(user).not_to be_valid
    end

    it 'ユーザの名前が30字以上' do
      user = build(:user, name: 'あ' * 31)
      expect(user).not_to be_valid
    end

    it 'ユーザのメールがない' do
      user = build(:user, email: nil)
      expect(user).not_to be_valid
    end

    it 'ユーザのメールが形式以外' do
      user = build(:user, email: 'testmail' + '/gmail.com')
      expect(user).not_to be_valid
    end

    it 'ユーザのメールが重複' do
      user1 = create(:user, email: 'asd@gmail.com')
      user2 = build(:user, email: 'asd@gmail.com')
      expect(user2).not_to be_valid
    end

    it 'メールアドレスが50字以上' do
      user = build(:user, email: 'a' * 41 + '@gmail.com')
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
