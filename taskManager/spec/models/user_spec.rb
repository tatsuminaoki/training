require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'ユーザ登録テスト' do
    subject { user.valid? }
    context "妥当なユーザの時" do
      let(:user) { FactoryBot.build(:user) }
      it "メールアドレス、ユーザ名、パスワードがあれば有効な状態であること" do
        is_expected.to be_truthy
      end
    end
    context "メールアドレスが無い時" do
      let(:user) { FactoryBot.build(:user, mail: nil) }
      it "メールアドレスが無ければ、無効な状態であること" do
        is_expected.to be_falsey
      end
    end
    context "メールアドレスフォーマットが無効" do
      let(:user) { FactoryBot.build(:user, mail: "iizuka") }
      it "メールアドレスで許可しないフォーマットの場合、無効な状態であること" do
        is_expected.to be_falsey
      end
    end
    context "メールアドレス文字数チェック(255以内) ローカル部64文字" do
      let(:mail) { "a" * 64 + "@" + "b" * 186 +  ".com" }
      let(:user) { FactoryBot.build(:user, mail: mail) }
      it "メールアドレスの文字数 = 255なら有効な状態であること" do
        expect(mail.size).to eq 255
        is_expected.to be_truthy
      end
    end
    context "メールアドレスローカル部が64文字を超える" do
      let(:mail) { "a" * 65 + "@" + "b" * 185 +  ".com" }
      let(:user) { FactoryBot.build(:user, mail: mail) }
      it "メールアドレスのローカル部が64文字なら無効な状態であること" do
        expect(mail.size).to eq 255
        is_expected.to be_falsey
      end
    end
    context "メールアドレス文字数チェック(>255)" do
      let(:mail) { "a" * 244 + "@example.com" }
      let(:user) { FactoryBot.build(:user, mail: mail) }
      it "メールアドレスの文字数 > 255なら無効な状態であること" do
        expect(mail.size).to eq 256
        is_expected.to be_falsey
      end
    end
    context "ユーザ名が無ければ、無効" do
      let(:user) {FactoryBot.build(:user, user_name: nil) }
      it "ユーザ名が無ければ、無効な状態であること" do
        is_expected.to be_falsey
      end
    end
    context "ユーザ名(255文字以内)" do
      let(:user) { FactoryBot.build(:user, user_name: "a" * 255) }
      it "ユーザー名の文字数 = 255なら有効な状態であること" do
        is_expected.to be_truthy
      end
    end
    context "ユーザ名(>255文字)" do
      let(:user) { FactoryBot.build(:user, user_name: "a" * 256) }
      it "ユーザー名の文字数 > 255なら無効な状態であること" do
        is_expected.to be_falsey
      end
    end
    context "ユーザ名(全角)" do
      let(:user) { FactoryBot.build(:user, user_name: "ああああ") }
      it "ユーザ名に全角文字列があっても、有効な状態であること" do
        is_expected.to be_truthy
      end
    end
    context "ユーザ名(スペース)" do
      let(:user) { FactoryBot.build(:user, user_name: "ああああ 飯塚") }
      it "ユーザ名にスペースがあっても、有効な状態であること" do
        is_expected.to be_truthy
      end
    end
    context "ユーザ名(スペース複数)" do
      let(:user) { FactoryBot.build(:user, user_name: "ああああ 飯塚 一") }
      it "ユーザ名にスペースが複数あった場合、無効な状態であること" do
        is_expected.to be_falsey
      end
    end
    context "パスワードが無い時" do
      let(:user) { FactoryBot.build(:user, password_digest: nil) }
      it "パスワードが無ければ、無効な状態であること" do
        is_expected.to be_falsey
      end
    end
    context "重複チェック" do
      let!(:user_tmp) { FactoryBot.create(:user, mail: "test10@example.com") }
      let!(:user) { FactoryBot.build(:user, mail: "test10@example.com") }
      it "重複したメールアドレスなら無効な状態であること" do
        is_expected.to be_falsey
      end
    end
    context "重複したメールアドレスなら無効な状態であること(大文字/小文字)" do
      let!(:user_tmp) { FactoryBot.create(:user, mail: "test10@example.com") }
      let!(:user) do  FactoryBot.build(:user, mail: "TEST10@EXAMPLE.COM")
      end
      it "重複したメールアドレスなら無効な状態であること(大文字/小文字)" do
        is_expected.to be_falsey
      end
    end
  end
end
