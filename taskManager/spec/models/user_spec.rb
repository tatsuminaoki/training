require 'rails_helper'

RSpec.describe User, type: :model do
  context '登録テスト' do
    it "メールアドレス、ユーザ名、パスワードがあれば有効な状態であること" do
      expect(FactoryBot.build(:user)).to be_valid
    end
    it "メールアドレスが無ければ、無効な状態であること" do
      user = FactoryBot.build(:user, mail: nil)
      user.valid?
      expect(user.errors[:mail]).to include("メールが空です。")
    end
    it "ユーザ名が無ければ、無効な状態であること" do
      user = FactoryBot.build(:user, user_name: nil)
      user.valid?
      expect(user.errors[:user_name]).to include("ユーザ名が空です。")
    end
    it "パスワードが無ければ、無効な状態であること" do
      user = FactoryBot.build(:user, encrypted_password: nil)
      user.valid?
      expect(user.errors[:encrypted_password]).to include("パスワードが空です。")
    end
    it "重複したメールアドレスなら無効な状態であること" do
      FactoryBot.create(:user, mail: "test1@example.com")
      user = FactoryBot.build(:user, mail: "test1@example.com")
      user.valid?
      expect(user.errors[:mail]).to include("は既に登録済みです。")
    end
  end
end
