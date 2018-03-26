require 'rails_helper'

describe User, type: :model do
  describe 'インスタンスの状態' do
    context '有効な場合' do
      it '名前、パスワード、確認パスワードがあれば有効な状態であること' do
        user = build(:user)
        expect(user).to be_valid
      end

      it '名前が20文字以下であれば有効な状態であること' do
        user = build(:user, name: 'a' * 20)
        expect(user).to be_valid
      end

      # has_secure_passwordのvalidation仕様
      # @see http://api.rubyonrails.org/classes/ActiveModel/SecurePassword/ClassMethods.html
      it 'パスワードが72文字以下であれば有効な状態であること' do
        user = build(:user, password: 'a' * 72, password_confirmation: 'a' * 72)
        expect(user).to be_valid
      end
    end

    context '無効な場合' do
      it '名前がなければ無効な状態であること' do
        user = build(:user, name: nil)
        expect(user).to be_invalid
        expect(user.errors[:name][0]).to eq I18n.t('errors.messages.empty')
      end

      it '名前が21文字以上の場合、無効な状態であること' do
        user = build(:user, name: 'a' * 21)
        expect(user).to be_invalid
        expect(user.errors[:name][0]).to eq I18n.t('errors.messages.too_long', count: 20)
      end

      it 'パスワードがなければ無効な状態であること' do
        user = build(:user, password: nil)
        expect(user).to be_invalid
        expect(user.errors[:password][0]).to eq I18n.t('errors.messages.empty')
      end

      it 'パスワードが73文字以上の場合、無効な状態であること' do
        user = build(:user, password: 'a' * 73)
        expect(user).to be_invalid
        expect(user.errors[:password][0]).to eq I18n.t('errors.messages.too_long', count: 72)
      end
    end
  end

  describe 'ユーザーが作成したタスクの関係性' do
    let!(:user) { create(:user) }

    it 'タスクにユーザーを紐付けて登録できること' do
      create(:task, user_id: user.id)
      expect(user.tasks.count).to eq 1
    end
  end
end
