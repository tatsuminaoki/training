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
    context "ユーザ名が無い時" do
      let(:user) { FactoryBot.build(:user, user_name: nil) }
      it "ユーザ名が無ければ、無効な状態であること" do
        is_expected.to be_falsey
        end
    end
    context "パスワードが無い時" do
      let(:user) { FactoryBot.build(:user, encrypted_password: nil) }
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
  end
end
