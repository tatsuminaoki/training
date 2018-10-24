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
  end
end
