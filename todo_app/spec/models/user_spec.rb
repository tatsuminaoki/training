require 'rails_helper'

describe User, type: :model do
  describe 'インスタンスの状態' do
    context '有効な場合' do
      it '名前があれば有効な状態であること' do
        user = build(:user)
        expect(user).to be_valid
      end

      it '名前が50文字以下であれば有効な状態であること' do
        user = build(:user, name: 'a' * 20)
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
    end
  end
end
