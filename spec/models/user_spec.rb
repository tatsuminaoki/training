require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'valid?' do
    let(:user) { create(:user) }

    context '名前がある場合' do
      it 'ユーザーが正常に作成される' do
        expect(user).to be_valid
      end
    end
    context '名前が無い場合' do
      it 'ユーザーの作成に失敗する' do
        user = build(:user, name: nil)
        expect(user).to be_invalid
      end
    end
  end
end
