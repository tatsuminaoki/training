# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'バリデーション' do
    it '名前、メールアドレス、パスワードがあれば有効な状態であること' do
      user = build(:user)
      expect(user).to be_valid
    end
    it '名前が無ければ無効な状態であること' do
      user = build(:user, name: '')
      expect(user).to be_invalid
    end
    it '名前が30文字であれば有効な状態であること' do
      user = build(:user, name: 'あ' * 30)
      expect(user).to be_valid
    end
    it '名前が31文字であれば無効な状態であること' do
      user = build(:user, name: 'あ' * 31)
      expect(user).to be_invalid
    end
    it 'メールアドレスが無ければ無効な状態であること' do
      user = build(:user, email: '')
      expect(user).to be_invalid
    end
    it 'メールアドレスが重複していれば無効な状態であること' do
      create(:user, email: 'aaa@example.com')
      user = build(:user, email: 'aaa@example.com')
      expect(user).to be_invalid
    end
    it 'メールアドレスが正しい形式で無ければ無効な状態であること' do
      user = build(:user, email: 'aaa')
      expect(user).to be_invalid
    end
    it 'メールアドレスが255文字であれば有効な状態であること' do
      user = build(:user, email: 'a@a.' + 'a' * 251)
      expect(user).to be_valid
    end
    it 'メールアドレスが266文字であれば無効な状態であること' do
      user = build(:user, email: 'a@a.' + 'a' * 252)
      expect(user).to be_invalid
    end
    it 'パスワードが無ければ無効な状態であること' do
      user = build(:user, password_digest: '')
      expect(user).to be_invalid
    end
    it 'パスワードが6文字であれば有効な状態であること' do
      user = build(:user, password_digest: 'a' * 6)
      expect(user).to be_valid
    end
    it 'パスワードが5文字であれば無効な状態であること' do
      user = build(:user, password_digest: 'a' * 5)
      expect(user).to be_invalid
    end
    it 'パスワードが30文字であれば有効な状態であること' do
      user = build(:user, password_digest: 'a' * 30)
      expect(user).to be_valid
    end
    it 'パスワードが31文字であれば無効な状態であること' do
      user = build(:user, password_digest: 'a' * 31)
      expect(user).to be_invalid
    end
  end
end
