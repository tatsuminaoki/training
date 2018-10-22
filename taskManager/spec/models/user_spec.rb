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
    it "メールアドレスで許可しないフォーマットの場合、無効な状態であること" do
      user = FactoryBot.build(:user, mail: "iizuka")
      user.valid?
      expect(user.errors[:mail]).to include("不正なフォーマットです。")
    end
    it "メールアドレスの文字数 = 255なら有効な状態であること" do
      mail = "a" * 243 + "@example.com"
      expect(mail.size).to eq 255
      expect(FactoryBot.build(:user, mail: mail)).to be_valid
    end
    it "メールアドレスの文字数 > 255なら無効な状態であること" do
      mail = "a" * 244 + "@example.com"
      user = FactoryBot.build(:user, mail: mail)
      user.valid?
      expect(mail.size).to eq 256
      expect(user.errors[:mail]).to include("256文字以上のメールアドレスを登録できません。")
    end
    it "ユーザ名が無ければ、無効な状態であること" do
      user = FactoryBot.build(:user, user_name: nil)
      user.valid?
      expect(user.errors[:user_name]).to include("ユーザ名が空です。")
    end
    it "ユーザー名の文字数 = 255なら有効な状態であること" do
      expect(FactoryBot.build(:user, user_name: "a" * 255)).to be_valid
    end
    it "ユーザー名の文字数 > 255なら有効な状態であること" do
      user = FactoryBot.build(:user, user_name: "a" * 256)
      user.valid?
      expect(user.errors[:user_name]).to include("256文字以上のユーザ名を登録できません。")
    end
    it "ユーザ名に全角文字列があっても、有効な状態であること" do
      expect(FactoryBot.build(:user, user_name: "ああああ")).to be_valid
    end
    it "ユーザ名にスペースがあっても、有効な状態であること" do
      expect(FactoryBot.build(:user, user_name: "ああああ 飯塚")).to be_valid
    end
    it "ユーザ名にスペースが複数あった場合、無効な状態であること" do
      user = FactoryBot.build(:user, user_name: "ああああ 飯塚 一")
      user.valid?
      expect(user.errors[:user_name]).to include("不正なフォーマットです。")
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
    it "重複したメールアドレスなら無効な状態であること(大文字/小文字)" do
      FactoryBot.create(:user, mail: "test1@example.com")
      user = FactoryBot.build(:user, mail: "TEST1@EXAMPLE.COM")
      user.valid?
      expect(user.errors[:mail]).to include("は既に登録済みです。")
    end
  end
end
