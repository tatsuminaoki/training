require 'rails_helper'

RSpec.describe Label, type: :model do
  describe 'ラベル登録テスト' do
    subject { label.valid? }
    context '妥当なラベルの時' do
      let(:label) { FactoryBot.build(:label) }
      it "ラベル名があれば有効な状態であること" do
        is_expected.to be_truthy
      end
    end
    context 'ラベル名が無い時' do
      let(:label) { FactoryBot.build(:label, label_name: nil) }
      it "ラベル名が無ければ、無効な状態であること" do
        is_expected.to be_falsey
      end
    end
    context '重複チェック' do
      let!(:label_tmp) { FactoryBot.create(:label, label_name: "label1") }
      let(:label) { FactoryBot.build(:label, label_name: "label1") }
      it "重複したメールアドレスなら無効な状態であること" do
        is_expected.to be_falsey
      end
    end
    context 'ラベル名(全角255文字以内)' do
      let(:label) { FactoryBot.build(:label, label_name: 'あ' * 255) }
      it "ラベル名の文字数 = 255なら無効な状態であること" do
        is_expected.to be_truthy
      end
    end
    context 'ラベル名(半角255文字以内)' do
      let(:label) { FactoryBot.build(:label, label_name: 'a' * 255) }
      it "ラベル名の文字数 = 255なら無効な状態であること" do
        is_expected.to be_truthy
      end
    end
    context 'ラベル名(>全角255文字)' do
      let(:label) { FactoryBot.build(:label, label_name: 'あ' * 256) }
      it "ラベル名の文字数 > 255の場合エラー(半角文字)" do
        is_expected.to be_falsey
      end
    end
    context 'ラベル名(>半角255文字)' do
      let(:label) { FactoryBot.build(:label, label_name: 'a' * 256) }
      it "ラベル名の文字数 > 255の場合エラー(半角文字)" do
        is_expected.to be_falsey
      end
    end
  end
end
