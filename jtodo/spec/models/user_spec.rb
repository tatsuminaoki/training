require 'rails_helper'

RSpec.describe User, type: :model do
  describe '#validation' do
    it '正常な値で登録できる' do
      user = build(:user)
      expect(user).to be_valid
    end

    it '不正な名前で登録すると名前エラーが発生する' do
      user = build(:user, name: nil)
      expect(user).to be_invalid
      expect(user.errors[:name]).to be_present
    end

    it '不正なパスワードで登録するとパスワードエラーが発生する' do
      user = build(:user, password: nil)
      expect(user).to be_invalid
      expect(user.errors[:password]).to be_present
    end

    it '短いパスワードで登録するとパスワードエラーが発生する' do
      user = build(:user, password: 'short')
      expect(user).to be_invalid
      expect(user.errors[:password]).to be_present
    end
  end
end
